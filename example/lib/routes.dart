import 'package:example/views/pages/exportPages.dart';
import 'package:flutter/material.dart';
import 'constants/constants.dart';

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