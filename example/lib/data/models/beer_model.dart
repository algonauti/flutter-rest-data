import 'package:flutter_rest_data/flutter_rest_data.dart';

import 'ingredient_model.dart';

class BeersModel extends JsonApiModel {
  // Constructors

  BeersModel(JsonApiDocument doc) : super(doc);

  BeersModel.init(String type) : super.init(type);

  // Attributes

  String get name => attributes['name'];

  set name(String value) => attributes['name'] = value;

  String get tagline => attributes['tagline'];

  set tagline(String value) => attributes['tagline'] = value;

  String get description => attributes['description'];

  set description(String value) => attributes['description'] = value;

  String get imageUrl => attributes['image_url'];

  set imageUrl(String value) => attributes['image_url'] = value;

  String get alcoholByVolume => attributes['alcohol_by_volume'];

  set alcoholByVolume(String value) => attributes['alcohol_by_volume'] = value;

  List<String> get foodPairing => attributes['food_pairing'];

  set foodPairing(List<String> value) => attributes['food_pairing'] = value;

  // Relationships

  List<IngredientModel> get ingredients =>
      includedDocs("ingredients").map((e) => IngredientModel(e)).toList();
}
