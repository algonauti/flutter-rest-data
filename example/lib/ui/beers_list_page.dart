import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rest_data_example/models/beer.dart';
import 'package:flutter_rest_data_example/ui/beers_list.dart';
import 'package:flutter_rest_data_example/ui/favorite_beers_list_page.dart';

class BeerListPage extends StatefulWidget {
  final List<Beer> _beers;

  BeerListPage({
    Key? key,
    required ManyBeers beers,
  })  : _beers = beers.toList(),
        super(key: key);

  @override
  _BeerListPageState createState() => _BeerListPageState();
}

class _BeerListPageState extends State<BeerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beers API Client'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            tooltip: 'Favorite beers',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoriteBeerListPage(
                          beers: widget._beers
                              .where((beer) => beer.starred)
                              .toList(),
                        )),
              );
            },
          ),
        ],
      ),
      body: BeersList(widget._beers),
    );
  }
}
