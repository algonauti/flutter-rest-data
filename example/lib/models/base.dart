import 'package:flutter_rest_data/flutter_rest_data.dart';
import 'package:flutter_rest_data_example/services/beer_api.dart';

class BaseModel extends JsonApiModel {
  BaseModel(JsonApiDocument jsonApiDoc) : super(jsonApiDoc);

  static PersistentJsonApiAdapter get adapter => BeerApiService().adapter;
}
