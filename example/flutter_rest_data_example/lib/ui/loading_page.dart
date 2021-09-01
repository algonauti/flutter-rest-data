import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rest_data/flutter_rest_data.dart';
import 'package:flutter_rest_data_example/data/beer_api_service.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  BeerApiService _apiService = BeerApiService();

  bool _isOffline = false;
  bool _isLoading = false;

  Exception? _lastLoadingError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beers API Client"),
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
          if (_lastLoadingError != null && !_isLoading)
            _buildError(_lastLoadingError!)
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

  Widget _buildError(Exception e) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_getHumanReadableErrorDescription(e)),
          ],
        ),
      ),
    );
  }

  String _getHumanReadableErrorDescription(Exception e) {
    if (e is NoNetworkError) {
      return 'Network is not available';
    } else if (e is NetworkError) {
      return 'Error while trying to access the server';
    }

    return 'Unexpected error';
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
      await _apiService.loadBeerList();
      _lastLoadingError = null;
    } on Exception catch (e) {
      _lastLoadingError = e;
    }
  }
}
