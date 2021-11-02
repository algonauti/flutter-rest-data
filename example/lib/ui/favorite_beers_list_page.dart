import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rest_data_example/models/beer.dart';
import 'package:flutter_rest_data_example/ui/beers_list.dart';

class FavoriteBeerListPage extends StatefulWidget {
  final List<Beer> _beers;

  FavoriteBeerListPage({
    Key? key,
    required List<Beer> beers,
  })  : _beers = beers,
        super(key: key);

  @override
  _FavoriteBeerListPageState createState() => _FavoriteBeerListPageState();
}

class _FavoriteBeerListPageState extends State<FavoriteBeerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: BeersList(widget._beers),
    );
  }
}
