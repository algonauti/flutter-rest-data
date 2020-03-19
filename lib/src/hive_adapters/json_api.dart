import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:rest_data/rest_data.dart';

class JsonApiHiveAdapter extends TypeAdapter<JsonApiDocument> {
  @override
  int get typeId => 81;

  final JsonApiSerializer serializer = JsonApiSerializer();
  final ZLibCodec zip = ZLibCodec();

  @override
  JsonApiDocument read(BinaryReader reader) {
    var compressedBytes = reader.readByteList();
    String json = utf8.decode(zip.decode(compressedBytes));
    return serializer.deserialize(json);
  }

  @override
  void write(BinaryWriter writer, JsonApiDocument document) {
    String json = serializer.serialize(document, withIncluded: true);
    var compressedBytes = zip.encode(utf8.encode(json));
    writer.writeByteList(compressedBytes);
  }
}
