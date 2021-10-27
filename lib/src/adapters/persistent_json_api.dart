import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rest_data/rest_data.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

import 'package:flutter_rest_data/src/db_adapters/json_api.dart';
import 'package:uuid/uuid.dart';

import '../exceptions.dart';

class PersistentJsonApiAdapter extends JsonApiAdapter {
  JsonApiStoreAdapter _storeAdapter = JsonApiStoreAdapter();
  late DatabaseFactory _dbFactory;
  late Database database;
  late String _dbName;

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

  Future<void> init({String databaseName = 'persistent_json_api.db'}) async {
    _dbName = databaseName;
    _dbFactory = databaseFactoryIo;
    var dbPath = await _buildDbPath(_dbName);
    await _openDatabase(dbPath);
  }

  Future<void> initTest() async {
    _dbName = 'flutter_rest_data.db';
    _dbFactory = databaseFactoryMemoryFs;
    await _openDatabase(_dbName);
  }

  Future<void> _openDatabase(String dbPath) async {
    database = await _dbFactory.openDatabase(dbPath);
  }

  Future<String> _buildDbPath(String dbName) async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    return join(dir.path, dbName);
  }

  Future<void> dispose() => database.close();

  Future<void> dropStores() => _dbFactory.deleteDatabase(_dbName);

  // TODO
  //  - when connection gets back:
  //    - invoke super.save() on each doc in the 'added' store (endpoint can be computed from type)
  //    - invoke super.delete() on each doc in the 'removed' store (endpoint can be computed from type)

  @override
  Future<JsonApiDocument> fetch(String endpoint, String id) async {
    JsonApiDocument? doc;
    if (isOnline) {
      doc = await super.fetch(endpoint, id);
      await storePutOne(endpoint, doc);
    } else {
      doc = await storeGetOne(endpoint, id);
    }
    return doc;
  }

  @override
  Future<JsonApiManyDocument> findAll(String endpoint) async {
    JsonApiManyDocument docs;
    if (isOnline) {
      docs = await super.findAll(endpoint);
      await storePutMany(endpoint, docs);
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
      await storePutMany(endpoint, docs);
    } else {
      if (params.containsKey('filter[id]')) {
        List<String> ids = params['filter[id]']!.split(',');
        docs = await storeGetMany(endpoint, ids);
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
      await storePutOne(endpoint, doc);
    } else {
      doc = await _persistWhileOffline(endpoint, document);
    }
    return doc;
  }

  Future<JsonApiDocument> _persistWhileOffline(
      String endpoint, JsonApiDocument document) async {
    final isAdding =
        document.id == null || await findAdded(document.id!) != null;
    if (isAdding) {
      final id = await storeAdd(endpoint, document);
      document.id = id;
    } else {
      await storeUpdate(endpoint, document);
    }
    cache(endpoint, document);
    return document;
  }

  @override
  Future<void> performDelete(String endpoint, JsonApiDocument doc) async {
    if (isOnline) {
      return super.performDelete(endpoint, doc);
    } else {
      var addedStore = openAddedStore();
      var addedRecord = addedStore.record(doc.id!);
      if (await addedRecord.exists(database)) {
        await addedRecord.delete(database);
        return;
      }
      await storeDelete(endpoint, doc);
      await openStringKeyStore(endpoint).record(doc.id!).delete(database);
    }
  }

  Future<JsonApiDocument> storeGetOne(String endpoint, String id) async {
    var store = openStringKeyStore(endpoint);

    var doc = await store.record(id).get(database);

    if (doc == null) {
      throw LocalRecordNotFoundException();
    }
    return _storeAdapter.fromMap(doc);
  }

  Future<JsonApiManyDocument> storeGetMany(
    String endpoint,
    Iterable<String> ids,
  ) async {
    var store = openStringKeyStore(endpoint);

    var docs = await store.records(ids).get(database).then(
          (maps) => maps
              .where((doc) => doc != null)
              .map((doc) => _storeAdapter.fromMap(doc!)),
        );

    if (ids.isNotEmpty && docs.isEmpty) {
      throw LocalRecordNotFoundException();
    }
    return JsonApiManyDocument(docs);
  }

  Future<void> storePutOne(String endpoint, JsonApiDocument doc) async {
    var store = openStringKeyStore(endpoint);

    await store.record(doc.id!).put(database, _storeAdapter.toMap(doc));
  }

  Future<void> storePutMany(String endpoint, JsonApiManyDocument docs) async {
    var store = openStringKeyStore(endpoint);

    await database.transaction((transaction) async {
      for (var doc in docs) {
        await store.record(doc.id!).put(transaction, _storeAdapter.toMap(doc));
      }
    });
  }

  Future<String> storeAdd(String endpoint, JsonApiDocument doc) async {
    final tempId = doc.id ?? Uuid().v1();
    doc.id = tempId;
    storePutOne(endpoint, doc);

    var store = openAddedStore();
    await store.record(tempId).delete(database);
    await store.record(tempId).add(database, {'endpoint': endpoint});
    return tempId;
  }

  Future<void> storeUpdate(String endpoint, JsonApiDocument doc) async {
    storePutOne(endpoint, doc);

    var store = openUpdatedStore();
    await store.record(doc.id!).delete(database);
    await store.record(doc.id!).add(database, {'endpoint': endpoint});
  }

  Future<void> storeDelete(String endpoint, JsonApiDocument doc) async {
    storePutOne(endpoint, doc);

    var store = openRemovedStore();
    await store.record(doc.id!).delete(database);
    await store.record(doc.id!).add(database, {'endpoint': endpoint});
  }

  Future<Iterable<JsonApiDocument>> addedByEndpoint(String endpoint) async {
    var addedStore = openAddedStore();

    var addedIds = (await addedStore.findKeys(
      database,
      finder: Finder(filter: Filter.equals('endpoint', endpoint)),
    ));

    var store = openStringKeyStore(endpoint);
    var list = (await store.records(addedIds).get(database))
        .where((e) => e != null)
        .map((e) => _storeAdapter.fromMap(e!))
        .toList();

    return list;
  }

  Future<JsonApiDocument?> findAdded(String id) async {
    var store = openAddedStore();
    var added = await store.record(id).get(database);
    if (added == null) return null;
    return peek(added['endpoint'].toString(), id);
  }

  Future<JsonApiManyDocument> findAllPersisted(String endpoint) async {
    var store = openStringKeyStore(endpoint);
    final docs = (await store.find(database, finder: Finder()))
        .map((e) => _storeAdapter.fromMap(e.value))
        .toList();
    return JsonApiManyDocument(docs);
  }

  StoreRef<String, Map<String, Object?>> openAddedStore() =>
      openStringKeyStore('added');

  StoreRef<String, Map<String, Object?>> openRemovedStore() =>
      openStringKeyStore('removed');

  StoreRef<String, Map<String, Object?>> openUpdatedStore() =>
      openStringKeyStore('updated');

  StoreRef<String, Map<String, Object?>> openStringKeyStore(String name) {
    return stringMapStoreFactory.store(name);
  }
}
