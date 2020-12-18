import 'package:flutter_rest_data/flutter_rest_data.dart';

class IngredientModel extends JsonApiModel {
  IngredientModel(JsonApiDocument doc) : super(doc);

  String get kind => attributes['kind'];

  set kind(String value) => attributes['kind'] = value;

  String get name => attributes['name'];

  set name(String value) => attributes['name'] = value;

  String get qty => attributes['qty'];

  set qty(String value) => attributes['qty'] = value;

  String get unit => attributes['unit'];

  set unit(String value) => attributes['unit'] = value;
}
