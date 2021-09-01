import 'package:flutter_rest_data/flutter_rest_data.dart';

class IngredientModel extends JsonApiModel {
  IngredientModel(JsonApiDocument jsonApiDoc) : super(jsonApiDoc);

  String get kind => attributes!['kind'];

  String get name => attributes!['name'];

  String get quantity => attributes!['qty'];

  String get unit => attributes!['unit'];
}
