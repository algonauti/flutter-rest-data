import 'package:flutter/material.dart';
import 'package:flutter_rest_data_example/services/beer_api.dart';
import 'package:flutter_rest_data_example/ui/loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BeerApiService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beer catalog example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingPage(),
    );
  }
}
