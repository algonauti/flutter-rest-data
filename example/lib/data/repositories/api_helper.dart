import 'package:example/data/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rest_data/flutter_rest_data.dart';
import 'package:example/constants/constants.dart';

class APIHelper<T>{

  PersistentJsonApiAdapter adapter;
  String path;


  APIHelper( this.path ) {
    adapterInit();
  }

  Future<void> adapterInit() async {

    adapter = PersistentJsonApiAdapter(APIConstants.API_HOST_NAME,APIConstants.API_PATH_NAME);
    adapter.init();

  }


  Future<dynamic> findAll() async {

    JsonApiManyDocument docs;
    try {
       docs = await adapter.findAll(path);
    }catch(e){
      print(e);
      return e.toString();
    }
      return docs.map<T>((jsonApiDoc) => Global.models[T](jsonApiDoc)).toList();

  }


  Future<dynamic> find(String id) async {


    JsonApiDocument docs;

    try {
      docs = await adapter.find(path,id,forceReload: true);
      print(docs.includedDocs("ingredients"));
      print(path);
    }catch(e){
      return e;
    }
    return Global.models[T](docs);

  }




  }





