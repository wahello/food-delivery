import 'package:flutter/material.dart';
import '../widgets/LatestProductList.dart';
import 'package:provider/provider.dart';
import '../../locator.dart';
import '../../core/Dish_list.dart';
import '../widgets/categories.dart';
import '../widgets/popularItems.dart';


class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Database.getInstance().getLatestMenuItems().then((products){
//      for(var p in products){
//        print(p.name);
//      }
//    });
    return ChangeNotifierProvider<FoodList>(
      create: (context) => locator<FoodList>(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12 ),
        child: ListView(

          children: <Widget>[
            LatestProductListView(),
            CategoriesView(),
            PopularItemListView(),

          ],
        ),
      ),
    );
  }
}
