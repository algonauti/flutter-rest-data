import 'dart:io';

import 'package:hive/hive.dart';

void initHive() {
  Hive.init(Directory.current.path);
}
