import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResults extends ChangeNotifier{
  SharedPreferences preferences;
  List<Product> products;
  List<Product> searchResult;
  SearchResults(List<Product> products){
    this.products=products;
    print('products.length:${products.length}');
    searchResult=List();
  }

  void performSearch(String search){
    print('performSearch:$search');
    search=search.toLowerCase();
    searchResult.clear();
    for(Product p in products){
      if(p.name.toLowerCase().contains(search)
      || p.description.toLowerCase().contains(search)
      || p.category.toLowerCase().contains(search)){
        searchResult.add(p);
      }
    }
    notifyListeners();
  }
}