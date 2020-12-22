import 'package:example/data/global.dart';
import 'package:flutter_rest_data/flutter_rest_data.dart';

class APIHelper<T> {
  PersistentJsonApiAdapter adapter;
  String path;
  String contentType = "application/json";
  String apiHost = "peaceful-hamlet-37069.herokuapp.com";
  String apiPath = "/api";

  static const String API_AUTH_TOKEN = '';
  APIHelper(this.path) {
    adapterInit();
  }
  Future<void> adapterInit() async {
    adapter = PersistentJsonApiAdapter(apiHost, apiPath);
    adapter.init();
  }

  Future<dynamic> findAll() async {
    JsonApiManyDocument docs;
    try {
      docs = await adapter.findAll(path);
    } catch (e) {
      return e.toString();
    }
    return docs.map<T>((jsonApiDoc) => Global.models[T](jsonApiDoc)).toList();
  }

  Future<dynamic> find(String id) async {
    JsonApiDocument docs;
    try {
      docs = await adapter.find(path, id, forceReload: true);
    } catch (e) {
      return e;
    }
    return Global.models[T](docs);
  }
}
