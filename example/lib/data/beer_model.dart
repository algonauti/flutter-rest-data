import 'package:flutter_rest_data/flutter_rest_data.dart';
import 'package:flutter_rest_data_example/data/ingredient_model.dart';

class BeerModel extends JsonApiModel {
  BeerModel(JsonApiDocument jsonApiDoc) : super(jsonApiDoc);

  String get name => attributes!['name'];

  String get tagline => attributes!['tagline'];

  String get description => attributes!['description'];

  String get imageUrl => attributes!['image_url'];

  String get alcoholByVolume => attributes!['alcohol_by_volume'];

  List<String> get foodPairing => attributes!['food_pairing'].cast<String>();

  Iterable<IngredientModel> get ingredients =>
      includedDocs("ingredients").map((jsonDoc) => IngredientModel(jsonDoc));
}
