import 'package:example/utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'routes.dart' as router;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
void main() {

  runApp(BeersApp());
}

class BeersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(

        builder:(context,constraints){
        SizeConfig().init(constraints);

     return  MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );

        }



    );
  }
}


