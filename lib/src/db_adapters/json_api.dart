import 'dart:convert';

import 'package:rest_data/rest_data.dart';

class JsonApiStoreAdapter {
  final JsonApiSerializer serializer = JsonApiSerializer();

  JsonApiDocument fromMap(Map<String, Object?> map) {
    String raw = json.encode(map);
    return serializer.deserialize(raw);
  }

  Map<String, Object?> toMap(JsonApiDocument document) {
    String raw = serializer.serialize(document, withIncluded: true);
    return json.decode(raw);
  }
}
