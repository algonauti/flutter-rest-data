import 'package:flutter_rest_data/flutter_rest_data.dart';

class BeerApiService {
  static const String _serviceUrl = 'peaceful-hamlet-37069.herokuapp.com';
  static const String _apiPath = '/api';

  static final BeerApiService _singleton = BeerApiService._instantiate();

  late PersistentJsonApiAdapter adapter;

  factory BeerApiService() {
    return _singleton;
  }

  BeerApiService._instantiate() {
    adapter = PersistentJsonApiAdapter(
      _serviceUrl,
      _apiPath,
    );
  }

  Future<void> initialize() async => await adapter.init();

  void setConnectionMode({required bool isOffline}) {
    if (isOffline) {
      adapter.setOffline();
    } else {
      adapter.setOnline();
    }
  }

  bool get isOnline => adapter.isOnline;
}
