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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder(
              future: Global.beers.find(widget.beerId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  beer = snapshot.data;
                  ingredients = beer.ingredients;
                  return Container(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(

                          child: Container(
                            height:800,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                _beetImageAndTitle,
                                 Expanded(child: _beerDetails)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xff26222F))));
                }
              });
        }
      ),
    );

  }




  Widget get _beetImageAndTitle=>(
      Column(
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
      )

  );


  Widget get _beerDetails=>(
      Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xff26222F),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Description",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),

              Text(
                beer.description.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),

              Text(
                "Ingredients",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),

              _chooseIngredient,

              _ingredientsData


            ],
          ))

  );

  Widget get _chooseIngredient =>(
      Global.beers.adapter.isOnline
          ? Container(
        height: 50,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            shrinkWrap: true,
            itemBuilder:
                (BuildContext ctxt, int i) {
              return _ingredientCircle(i);
            }),
      )
          : Container()


  );



  Widget _ingredientCircle(int i)=>(
      Padding(
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
      )

  );



  Widget get _ingredientsData =>(


      Global.beers.adapter.isOnline  ?   Row(
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
      ) : Container(
          child: Text(
            "In order to check the ingredients kindly go online",
            style:
            TextStyle(color: Colors.yellow),
          ))



  );

//  Widget get _helloBabe  => (Container(child: Text("no waay")));


}
