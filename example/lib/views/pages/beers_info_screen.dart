import 'package:example/data/global.dart';
import 'package:example/data/models/beer_model.dart';
import 'package:example/data/models/ingredient_model.dart';
import 'package:example/utils/size_config.dart';
import 'package:flutter/material.dart';

class BeersInfoScreen extends StatefulWidget {
  final String beerId;

  const BeersInfoScreen({Key key, this.beerId}) : super(key: key);

  @override
  _BeersInfoScreenState createState() => _BeersInfoScreenState();
}

class _BeersInfoScreenState extends State<BeersInfoScreen> {
  BeersModel beer;
  List<IngredientModel> ingredients;
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beers API Client"),
        backgroundColor: Color(0xff26222F),
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: SizeConfig.heightMultiplier * 100,
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: Global.beers.find(widget.beerId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  beer = snapshot.data;
                  ingredients = beer.ingredients;
                  return Container(
                    height: SizeConfig.heightMultiplier * 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 10,
                              ),
                              Image.network(
                                beer.imageUrl,
                                width: 60,
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 2,
                              ),
                              Text(beer.name,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                              Text(
                                beer.tagline,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 5,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color(0xff26222F),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 2,
                                  ),
                                  Text(
                                    beer.description.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 2,
                                  ),
                                  Text(
                                    "Ingredients",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 2,
                                  ),
                                  Global.beers.adapter.isOnline
                                      ? Container(
                                          height: 50,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: ingredients.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext ctxt, int i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex = i;
                                                          });
                                                        },
                                                        child: Container(
                                                          child:
                                                              Text("${i + 1}"),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 50,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              color: Color(
                                                                  0xffFFB54C),
                                                              border: selectedIndex ==
                                                                      i
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .white)
                                                                  : null),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 2,
                                  ),
                                  Global.beers.adapter.isOnline
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                    "Name: ${ingredients[selectedIndex].name}",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .heightMultiplier *
                                                      2,
                                                ),
                                                Text(
                                                  "Kind: ${ingredients[selectedIndex].kind} ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Quantity: ${ingredients[selectedIndex].qty} ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .heightMultiplier *
                                                      2,
                                                ),
                                                Text(
                                                  "Unit: ${ingredients[selectedIndex].unit}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      : Container(
                                          child: Text(
                                          "In order to check the ingredients kindly go online",
                                          style:
                                              TextStyle(color: Colors.yellow),
                                        )),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 5,
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xff26222F))));
                }
              }),
        ),
      ),
    );
  }
}
