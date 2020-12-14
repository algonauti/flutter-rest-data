import 'package:flutter/material.dart';

class BeerContainer extends StatelessWidget {
  final beerName;
  final imageUrl;
  final alcoholByVolume;
  final index;
  final tagLine;

  const BeerContainer({Key key, this.beerName, this.imageUrl, this.alcoholByVolume,this.index,this.tagLine}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom:10.0,top: 10),
      child: ListTile(
        leading: Image.network(imageUrl,width: 20,),
        trailing: Text("ALC.$alcoholByVolume"),
        subtitle: Text(tagLine),
        title: Text(beerName,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }
}
