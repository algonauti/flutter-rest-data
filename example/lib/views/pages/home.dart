import 'package:example/data/global.dart';
import 'package:example/data/models/beer_model.dart';
import 'package:example/utils/size_config.dart';
import 'package:example/views/pages/beers_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;
  bool isLoading = false;
  String onError = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Beers API Client"),
            backgroundColor: Color(0xff26222F),
          ),
          backgroundColor: Colors.white,
          body: Container(
            height: SizeConfig.heightMultiplier * 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Simulate offline",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
                _offlineSwitch,
                _loadBeersButton,
                Text(onError),
              ],
            ),
          )),
    );
  }

  Widget get _loadBeersButton => ButtonTheme(
        buttonColor: Color(0xffFFB54C),
        child: RaisedButton(
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff26222F)),
                )
              : Text(
                  'Load Beers',
                  style: TextStyle(color: Colors.black),
                ),
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            Global.beers.findAll().then((value) {
              if (value is List<BeersModel>) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BeersScreen(
                            beers: value,
                          )),
                );
              } else {
                setState(() {
                  onError = value;
                });
              }
              setState(() {
                isLoading = false;
              });
            });
          },
        ),
      );

  Widget get _offlineSwitch => CupertinoSwitch(
        activeColor: Color(0xff26222F),
        value: isSwitched,
        onChanged: (bool value) {
          setState(() {
            isSwitched = value;
          });
          value
              ? Global.beers.adapter.setOffline()
              : Global.beers.adapter.setOnline();
        },
      );
}
