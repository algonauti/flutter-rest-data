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

      test(
          'performDelete() places document id to "removed" store and removed document from store',
          () async {
        await adapter.performDelete('docs', doc1);
        var remaining = await adapter.findAll('docs');
        expect(remaining.length, docs.length - 1);

        var removed = await adapter
            .openRemovedStore()
            .find(adapter.database, finder: sembast.Finder());
        expect(removed.length, 1);
      });

      test('save() places new document id to "added" store', () async {
        var newDoc = createJsonApiDocument(null);
        newDoc = await adapter.save('docs', newDoc);
        var remaining = await adapter.findAll('docs');
        expect(remaining.length, docs.length + 1);

        var addedStore = adapter.openAddedStore();
        var added = await addedStore.find(adapter.database);
        expect(added.length, 1);

        // second save should not duplicate data
        newDoc.setAttribute('attribute_one', 'another_value');
        newDoc = await adapter.save('docs', newDoc);

        remaining = await adapter.findAll('docs');
        expect(remaining.length, docs.length + 1);

        added = await addedStore.find(adapter.database);
        expect(added.length, 1);
      });

      test('save() places new document ids in correct order', () async {
        var newDoc1 = createJsonApiDocument(null);
        var newDoc2 = createJsonApiDocument(null);
        var newDoc3 = createJsonApiDocument(null);
        newDoc1 = await adapter.save('docs', newDoc1);
        newDoc2 = await adapter.save('docs', newDoc2);
        newDoc3 = await adapter.save('docs', newDoc3);
        var remaining = await adapter.findAll('docs');
        expect(remaining.length, docs.length + 3);

        var added = await adapter
            .openAddedStore()
            .find(adapter.database, finder: sembast.Finder());
        expect(added.length, 3);
        expect(added[0].key, newDoc1.id);
        expect(added[1].key, newDoc2.id);
        expect(added[2].key, newDoc3.id);
      });

      test('save() places existing document id to "updated" store', () async {
        final existingDoc = doc2;
        existingDoc.setAttribute('attribute_one', 'new_value');
        await adapter.save('docs', existingDoc);
        var remaining = await adapter.findAll('docs');
        expect(remaining.length, docs.length);

        var added = await adapter
            .openUpdatedStore()
            .find(adapter.database, finder: sembast.Finder());
        expect(added.length, 1);
      });
    });
  });
}

JsonApiDocument createJsonApiDocument(String? id) =>
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
