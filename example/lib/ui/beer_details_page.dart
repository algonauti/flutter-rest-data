import 'package:flutter/material.dart';
import 'package:flutter_rest_data_example/models/beer.dart';
import 'package:flutter_rest_data_example/models/ingredient.dart';
import 'package:flutter_rest_data_example/ui/error_presenter.dart';

class BeerDetailsPage extends StatefulWidget {
  final String _beerId;

  BeerDetailsPage({
    Key? key,
    required String beerId,
  })  : _beerId = beerId,
        super(key: key);

  @override
  _BeerDetailsPageState createState() {
    return _BeerDetailsPageState();
  }
}

class _BeerDetailsPageState extends State<BeerDetailsPage> {
  bool _isLoading = false;
  Beer? _beer;

  @override
  void initState() {
    _loadBeerDetails(beerId: widget._beerId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beers API Client'),
      ),
      body: _isLoading
          ? _buildLoadingProgress()
          : _buildBeerDetails(context, beer: _beer),
    );
  }

  Widget _buildLoadingProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBeerDetails(
    BuildContext context, {
    required Beer? beer,
  }) {
    if (beer == null) {
      return Center(
        child: Text('Beer info is unavailable'),
      );
    }

    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                beer.imageUrl,
                height: 144,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return SizedBox(
                    width: 144,
                    height: 144,
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Text(beer.name, style: textTheme.headline5),
            SizedBox(height: 8),
            Text(
              beer.tagline,
              style: textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              beer.description,
              style: textTheme.subtitle2,
            ),
            SizedBox(height: 8),
            Text('Alcohol by volume: ${beer.alcoholByVolume}'),
            SizedBox(height: 16),
            Text(
              'Food pairing: ',
              style: textTheme.subtitle2,
            ),
            SizedBox(height: 8),
            ...beer.foodPairing.map((pairing) => Text('- $pairing')),
            SizedBox(height: 16),
            ..._renderIngredients(context, ingredients: beer.ingredients),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> _renderIngredients(
    BuildContext context, {
    required Iterable<IngredientModel> ingredients,
  }) {
    if (ingredients.isEmpty) {
      return [];
    }

    final textTheme = Theme.of(context).textTheme;

    return [
      Text(
        'Ingredients:',
        style: textTheme.subtitle2,
      ),
      SizedBox(height: 8),
      ...ingredients.map((ingredient) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIngredientInfoRow(
                infoTitle: 'Kind: ',
                infoValue: ingredient.kind,
              ),
              _buildIngredientInfoRow(
                infoTitle: 'Name: ',
                infoValue: ingredient.name,
              ),
              _buildIngredientInfoRow(
                infoTitle: 'Quantity: ',
                infoValue: '${ingredient.quantity} ${ingredient.unit}',
              ),
              SizedBox(height: 8),
            ],
          ))
    ];
  }

  Widget _buildIngredientInfoRow({
    required String infoTitle,
    required String infoValue,
  }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: infoTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: infoValue),
        ],
      ),
    );
  }

  void _loadBeerDetails({required String beerId}) async {
    setState(() {
      _isLoading = true;
    });

    final loadedBeer = await _safelyLoadBeerDetails(beerId);

    setState(() {
      _beer = loadedBeer;
      _isLoading = false;
    });
  }

  Future<Beer?> _safelyLoadBeerDetails(String beerId) async {
    try {
      return await Beer.find(beerId, forceReload: true);
    } on Exception catch (e) {
      ErrorPresenter.showError(context, error: e);
      return null;
    }
  }
}
