import 'package:example/views/pages/export_pages.dart';
import 'package:flutter/material.dart';

class AppRouteName {
  static const String HOME_SCREEN = "/home";
  static const String BEERS_SCREEN = "/beersScreen";
  static const String BEER_INFO_SCREEN = "/beerInfoScreen";
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case AppRouteName.BEERS_SCREEN:
      return MaterialPageRoute(builder: (_) => BeersScreen());
      break;
    case AppRouteName.BEER_INFO_SCREEN:
      return MaterialPageRoute(builder: (_) => BeersInfoScreen());
      break;
    default:
      return MaterialPageRoute(builder: (_) => HomeScreen());
  }
}
