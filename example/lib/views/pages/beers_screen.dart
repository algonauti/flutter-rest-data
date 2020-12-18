import 'package:example/data/models/beer_model.dart';
import 'package:example/utils/size_config.dart';
import 'package:example/views/pages/beers_info_screen.dart';
import 'package:example/views/partials/beer_container.dart';
import 'package:flutter/material.dart';

class BeersScreen extends StatefulWidget {
  final List<BeersModel> beers;

  const BeersScreen({Key key, this.beers}) : super(key: key);

  @override
  _BeersScreenState createState() => _BeersScreenState();
}

class _BeersScreenState extends State<BeersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "We found ${widget.beers.length} beers",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        backgroundColor: Color(0xff26222F),
      ),
      backgroundColor: Color(0xff26222F),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Beers List",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 5,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.beers.length,
                  itemBuilder: (BuildContext ctxt, int i) {
                    return Container(
                        child: GestureDetector(
                      child: BeerContainer(
                        beerName: widget.beers[i].name,
                        imageUrl: widget.beers[i].imageUrl,
                        alcoholByVolume: widget.beers[i].alcoholByVolume,
                        index: i,
                        tagLine: widget.beers[i].tagline,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BeersInfoScreen(
                                    beerId: widget.beers[i].id,
                                  )),
                        );
                      },
                    ));
                  }),
            ),
          )
        ],
      ),
    );
  }


}
