import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rest_data/rest_data.dart';

import '../exceptions.dart';
import '../hive_adapters/json_api.dart';

class PersistentJsonApiAdapter extends JsonApiAdapter {
  PersistentJsonApiAdapter(
    String hostname,
    String apiPath, {
    bool useSSL: true,
  }) : super(
          hostname,
          apiPath,
          useSSL: useSSL,
        );

  bool isOnline = true;

  void setOnline() {
    isOnline = true;
  }

  void setOffline() {
    isOnline = false;
  }

  Future<void> init() async {
    await Hive.initFlutter();
    registerAdapters();
  }

  void initTest() {
    registerAdapters();
  }

  void registerAdapters() {
    Hive.registerAdapter(JsonApiHiveAdapter());
  }

  Future<void> dispose() => Hive.close();

  Future<void> dropBoxes() => Hive.deleteFromDisk();

  // TODO
  //  - when connection gets back:
  //    - invoke super.save() on each doc in the 'added' box (endpoint can be computed from type)
  //    - invoke super.delete() on each doc in the 'removed' box (endpoint can be computed from type)

  @override
  Future<JsonApiDocument> fetch(String endpoint, String id) async {
    JsonApiDocument? doc;
    if (isOnline) {
      doc = await super.fetch(endpoint, id);
      await boxPutOne(endpoint, doc);
    } else {
      doc = id.contains('added')
          ? (await findAdded(id))
          : (await boxGetOne(endpoint, id));
    }
    return doc!;
  }

  @override
  Future<JsonApiManyDocument> findAll(String endpoint) async {
    JsonApiManyDocument docs;
    if (isOnline) {
      docs = await super.findAll(endpoint);
      await boxPutMany(endpoint, docs);
    } else {
      docs = await findAllPersisted(endpoint);
      cacheMany(endpoint, docs);
    }
    return docs;
  }

  @override
  Future<JsonApiManyDocument> query(String endpoint, Map<String, String> params,
      {FilterFunction? filter}) async {
    JsonApiManyDocument docs;
    if (isOnline) {
      docs = await super.query(endpoint, params);
      await boxPutMany(endpoint, docs);
    } else {
      if (params.containsKey('filter[id]')) {
        List<String> ids = params['filter[id]']!.split(',');
        docs = await boxGetMany(endpoint, ids);
      } else {
        docs = await findAllPersisted(endpoint);
        if (filter != null) {
          docs.filter(filter);
        }
      }
      cacheMany(endpoint, docs);
    }
    return docs;
  }

  @override
  Future<JsonApiDocument> save(String endpoint, Object document) async {
    if (document is! JsonApiDocument) {
      throw ArgumentError('document must be a JsonApiDocument');
    }
    JsonApiDocument doc;
    if (isOnline) {
      doc = await super.save(endpoint, document);
      await boxPutOne(endpoint, doc);
    } else {
      // TODO Handle Update case
      doc = document;
      int id = await boxAdd(endpoint, doc);
      doc.id = 'added:$id';
      cache(endpoint, doc);
    }
    return doc;
  }

  @override
  Future<void> performDelete(String endpoint, JsonApiDocument doc) async {
    if (isOnline) {
      return super.performDelete(endpoint, doc);
    } else {
      var removedBox = await openBox('removed');
      await removedBox.put('$endpoint:${doc.id}', doc);
      (await openBox(endpoint)).delete(doc.id);
    }
  }

  Future<Box<JsonApiDocument?>> openBox(String name) =>
      Hive.openBox<JsonApiDocument?>(name);

  Future<JsonApiDocument> boxGetOne(String endpoint, String id) async {
    var box = await openBox(endpoint);
    var doc = box.get(id);
    if (doc == null) {
      throw LocalRecordNotFoundException();
    }
    return doc;
  }

  Future<JsonApiManyDocument> boxGetMany(
    String endpoint,
    Iterable<String> ids,
  ) async {
    var box = await openBox(endpoint);
    var docs =
        ids.map((id) => box.get(id)).where((doc) => doc != null).toList();
    if (ids.isNotEmpty && docs.isEmpty) {
      throw LocalRecordNotFoundException();
    }
    return JsonApiManyDocument(docs);
  }

  Future<void> boxPutOne(String endpoint, JsonApiDocument doc) async {
    var box = await openBox(endpoint);
    await box.put(doc.id, doc);
  }

  Future<void> boxPutMany(String endpoint, JsonApiManyDocument docs) async {
    var box = await openBox(endpoint);
    var puts = <Future>[];
    docs.forEach((doc) {
      puts.add(box.put(doc!.id, doc));
    });
    await Future.wait(puts);
  }

  Future<int> boxAdd(String endpoint, JsonApiDocument doc) async {
    var box = await openBox('added');
    int id = await box.add(doc);
    return id;
  }

  Future<Iterable<JsonApiDocument?>> addedByEndpoint(String endpoint) async {
    var box = await openBox('added');
    return box.values.where((doc) => doc!.endpoint == endpoint);
  }

  Future<JsonApiDocument?> findAdded(String id) async {
    var key = int.parse(id.replaceAll('added:', ''));
    var box = await openBox('added');
    return box.get(key);
  }

  Future<JsonApiManyDocument> findAllPersisted(String endpoint) async {
    var box = await openBox(endpoint);
    var docs = box.values.toList();
    docs.addAll(await addedByEndpoint(endpoint));
    return JsonApiManyDocument(docs);
  }
}
