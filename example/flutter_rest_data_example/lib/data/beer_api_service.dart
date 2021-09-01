import 'package:flutter_rest_data/flutter_rest_data.dart';
import 'package:flutter_rest_data_example/data/beer_model.dart';

class BeerApiService {
  static final BeerApiService _singleton = BeerApiService._instantiate();

  late PersistentJsonApiAdapter _jsonApiAdapter;

  factory BeerApiService() {
    return _singleton;
  }

  BeerApiService._instantiate() {
    _jsonApiAdapter = PersistentJsonApiAdapter(
      'peaceful-hamlet-37069.herokuapp.com',
      '/api',
    );
  }

  Future<void> initialize() async => await _jsonApiAdapter.init();

  void setConnectionMode({required bool isOffline}) {
    if (isOffline) {
      _jsonApiAdapter.setOffline();
    } else {
      _jsonApiAdapter.setOnline();
    }
  }

  bool get isOnline => _jsonApiAdapter.isOnline;

  Future<Iterable<BeerModel>> loadBeerList() async {
    final beersJson = await _jsonApiAdapter.findAll('beers');

    return beersJson.docs
        .where((element) => element != null)
        .map((beerJson) => BeerModel(beerJson!));
  }
}
