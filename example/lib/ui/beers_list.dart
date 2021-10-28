import 'package:flutter/material.dart';
import 'package:flutter_rest_data_example/models/beer.dart';
import 'package:flutter_rest_data_example/ui/beer_details_page.dart';

class BeersList extends StatefulWidget {
  final List<Beer> _beers;

  BeersList(List<Beer> beers) : _beers = beers;

  @override
  State<StatefulWidget> createState() => _BeersListState(_beers);
}

class _BeersListState extends State {
  final List<Beer> _beers;

  _BeersListState(List<Beer> beers) : _beers = beers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _beers.length,
        itemBuilder: (context, index) {
          return _buildBeerListItem(context, beer: _beers[index]);
        });
  }

  Widget _buildBeerListItem(BuildContext context, {required Beer beer}) {
    return ListTile(
      title: Text(beer.name),
      subtitle: Text(beer.tagline),
      leading: Image.network(
        beer.imageUrl,
        width: 48,
        height: 48,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
      trailing: IconButton(
        icon: Icon(beer.starred ? Icons.star : Icons.star_outline),
        onPressed: () {
          setState(() {
            final beerIndex = _beers.indexOf(beer);
            beer.starred = !beer.starred;
            beer.saveDoc();
            _beers[beerIndex] = beer;
          });
        },
      ),
      onTap: () {
        final beerId = beer.id;

        if (beerId == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BeerDetailsPage(
                    beerId: beerId,
                  )),
        );
      },
    );
  }
}
