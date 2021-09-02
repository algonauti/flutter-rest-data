import 'package:flutter_rest_data/flutter_rest_data.dart';
import 'package:flutter_rest_data_example/data/beer_model.dart';

class BeerApiService {
  static const String _SERVICE_URL = 'peaceful-hamlet-37069.herokuapp.com';
  static const String _API_PATH = '/api';
  static const String _BEERS_ENDPOINT = 'beers';

  static final BeerApiService _singleton = BeerApiService._instantiate();

  late PersistentJsonApiAdapter _jsonApiAdapter;

  factory BeerApiService() {
    return _singleton;
  }

  BeerApiService._instantiate() {
    _jsonApiAdapter = PersistentJsonApiAdapter(
      _SERVICE_URL,
      _API_PATH,
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
    final beersJson = await _jsonApiAdapter.findAll(_BEERS_ENDPOINT);

    return beersJson.docs
        .where((element) => element != null)
        .map((beerJson) => BeerModel(beerJson!));
  }

  Future<BeerModel> loadSingleBeer({
    required String beerId,
    bool forceReload = false,
  }) async {
    final beerJson = await _jsonApiAdapter.find(
      _BEERS_ENDPOINT,
      beerId,
      forceReload: forceReload,
    );

    return BeerModel(beerJson);
  }
}
