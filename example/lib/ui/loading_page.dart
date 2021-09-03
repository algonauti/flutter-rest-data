import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rest_data_example/services/beer_api.dart';
import 'package:flutter_rest_data_example/ui/beers_list_page.dart';
import 'package:flutter_rest_data_example/ui/error_presenter.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  BeerApiService _apiService = BeerApiService();

  bool _isOffline = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beers API Client'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 96,
          ),
          SwitchListTile(
            title: const Text('Simulate offline'),
            value: _isOffline,
            onChanged: _toggleOffline,
          ),
          SizedBox(
            height: 24,
          ),
          _buildLoadingButton(context),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  MaterialButton _buildLoadingButton(BuildContext context) {
    return MaterialButton(
      onPressed: _isLoading ? null : () => _loadBeers(context),
      minWidth: 120,
      height: 48,
      color: Theme.of(context).accentColor,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Load beers',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
    );
  }

  void _toggleOffline(bool shouldWorkOffline) {
    _apiService.setConnectionMode(isOffline: shouldWorkOffline);
    setState(() {
      _isOffline = !_apiService.isOnline;
    });
  }

  void _loadBeers(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await _safelyLoadBeers(context);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _safelyLoadBeers(BuildContext context) async {
    try {
      final beers = await _apiService.loadBeerList();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BeerListPage(
                  beerList: beers.toList(),
                )),
      );
    } on Exception catch (e) {
      ErrorPresenter.showError(context, error: e);
    }
  }
}
