import 'package:flutter_rest_data/flutter_rest_data.dart';

class IngredientModel extends JsonApiModel {
  IngredientModel(JsonApiDocument jsonApiDoc) : super(jsonApiDoc);

  String get kind => getAttribute<String>('kind');

  String get name => getAttribute<String>('name');

  double get quantity => double.parse(getAttribute<String>('qty'));

  String get unit => getAttribute<String>('unit');
}
