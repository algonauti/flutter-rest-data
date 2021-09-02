import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rest_data_example/data/beer_model.dart';
import 'package:flutter_rest_data_example/ui/beer_details_page.dart';
import 'package:flutter_rest_data_example/ui/global_strings.dart';

class BeerListPage extends StatefulWidget {
  final List<BeerModel> _beerList;

  BeerListPage({
    Key? key,
    required List<BeerModel> beerList,
  })  : _beerList = beerList,
        super(key: key);

  @override
  _BeerListPageState createState() => _BeerListPageState();
}

class _BeerListPageState extends State<BeerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APPBAR_TITLE),
      ),
      body: ListView.builder(
          itemCount: widget._beerList.length,
          itemBuilder: (context, index) {
            return _buildBeerListItem(context, beer: widget._beerList[index]);
          }),
    );
  }

  Widget _buildBeerListItem(BuildContext context, {required BeerModel beer}) {
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
