import 'package:flutter_rest_data/flutter_rest_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';
import 'package:sembast/sembast.dart' as sembast;

void main() {
  group('PersistentJsonApiAdapter', () {
    late PersistentJsonApiAdapter adapter;

    before() async {
      adapter = PersistentJsonApiAdapter(
        'host.example.com',
        '/path/to/rest/api',
      );
      await adapter.initTest();
    }

    after() async {
      await adapter.dropStores();
    }

    group('when offline', () {
      JsonApiDocument doc1 = createJsonApiDocument('1');
      JsonApiDocument doc2 = createJsonApiDocument('2');
      JsonApiDocument doc3 = createJsonApiDocument('3');
      JsonApiManyDocument docs = JsonApiManyDocument([doc1, doc2, doc3]);

      setUp(before);
      tearDown(after);

      setUp(() async {
        adapter.setOffline();
        await adapter.storePutMany('docs', docs);
      });

      test('find() returns requested JsonApiDocument from database', () async {
        var doc = await adapter.find('docs', '1');
        expect(doc is JsonApiDocument, isTrue);
        expect(doc.id, '1');
        expect(
          DeepCollectionEquality().equals(doc.attributes, doc1.attributes),
          isTrue,
        );
        expect(
          DeepCollectionEquality()
              .equals(doc.relationships, doc1.relationships),
          isTrue,
        );
      });

      test('findMany() returns requested JsonApiDocument objects from database',
          () async {
        var requestedIds = ['1', '2'];
        var returnedDocs = await adapter.findMany('docs', requestedIds);
        expect(returnedDocs is JsonApiManyDocument, isTrue);
        expect(returnedDocs.length, 2);
        var returnedIds = returnedDocs.map((doc) => doc.id);
        expect(returnedIds.toSet().containsAll(requestedIds), isTrue);
        expect(requestedIds.toSet().containsAll(returnedIds), isTrue);
      });

      test('findAll() returns all JsonApiDocument objects from database',
          () async {
        var allIds = ['1', '2', '3'];
        var returnedDocs = await adapter.findAll('docs');
        expect(returnedDocs is JsonApiManyDocument, isTrue);
        expect(returnedDocs.length, 3);
        var returnedIds = returnedDocs.map((doc) => doc.id);
        expect(returnedIds.toSet().containsAll(allIds), isTrue);
        expect(allIds.toSet().containsAll(returnedIds), isTrue);
      });

      test('performDelete() moves document to "removed" store', () async {
        await adapter.performDelete('docs', doc1);
        var remaining = await adapter.findAll('docs');
        expect(remaining.length, docs.length - 1);

        var removed = await adapter
            .openStringKeyStore('removed')
            .find(adapter.database, finder: sembast.Finder());
        expect(removed.length, 1);
      });
    });
  });
}

JsonApiDocument createJsonApiDocument(String id) =>
    JsonApiDocument(id, 'model_type_1', {
      'attribute_one': 'value_one',
      'attribute_two': 'value_two',
    }, {
      'has_one_relationship': {
        'data': {'id': 'unique_ID_2', 'type': 'model_type_2'}
      },
      'has_many_relationhip': {
        'data': [
          {'id': 'unique_ID_3', 'type': 'model_type_3'},
          {'id': 'unique_ID_4', 'type': 'model_type_3'},
        ]
      },
    });
