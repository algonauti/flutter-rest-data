import 'package:flutter_rest_data/flutter_rest_data.dart';
import 'package:flutter_rest_data_example/models/base.dart';
import 'package:flutter_rest_data_example/models/ingredient.dart';

class Beer extends BaseModel {
  Beer(JsonApiDocument jsonApiDoc) : super(jsonApiDoc);

  static final String _endpoint = 'beers';

  static Future<Beer> find(String id, {bool forceReload = false}) async => Beer(
        await BaseModel.adapter.find(_endpoint, id, forceReload: forceReload),
      );

  static Future<ManyBeers> findAll() async =>
      ManyBeers(await BaseModel.adapter.findAll(_endpoint));

  String get name => attributes['name'];

  String get tagline => attributes['tagline'];

  String get description => attributes['description'];

  String get imageUrl => attributes['image_url'];

  String get alcoholByVolume => attributes['alcohol_by_volume'];

  List<String> get foodPairing => attributes['food_pairing'].cast<String>();

  Iterable<IngredientModel> get ingredients =>
      includedDocs('ingredients').map((jsonDoc) => IngredientModel(jsonDoc));
}

class ManyBeers extends JsonApiManyModel<Beer> {
  ManyBeers(JsonApiManyDocument manyDoc) : super(manyDoc) {
    models = manyDoc.map<Beer>((jsonApiDoc) => Beer(jsonApiDoc!));
  }
}
