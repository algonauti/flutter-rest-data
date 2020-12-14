import 'package:example/data/models/beersModel.dart';
import 'package:example/data/models/ingredientModel.dart';
import 'package:example/data/repositories/api_helper.dart';

class Global{

  static final Map models = {
    BeersModel: (doc) => BeersModel(doc),
    IngredientModel: (doc) => IngredientModel(doc),



  };



  static final APIHelper<BeersModel> beers = APIHelper<BeersModel>("beers");
  static final APIHelper<IngredientModel> ingredients = APIHelper<IngredientModel>("ingredients");


}