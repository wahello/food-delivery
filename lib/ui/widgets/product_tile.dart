
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/ui/views/itemDetails.dart';
import 'package:provider/provider.dart';
import '../shared/text_styles.dart' as style;

class ProductTileWidget extends StatelessWidget {
  final Product product;

  ProductTileWidget({this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 22),
      child: GestureDetector(
        onTap: (){
          FavouriteProducts favouriteProducts=Provider.of<FavouriteProducts>(context,listen: false);
          Navigator.push(context, MaterialPageRoute(builder: (_)=> ItemDetails(product: product,favouriteProducts: favouriteProducts,))) ;
        },
        child: Container(
          height: size.height * 0.15,
          width: size.width * 0.9,
          child: Row(
            children: <Widget>[
              Hero(
                transitionOnUserGestures: true,
                tag:product.id ,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    product.images[0],
                    width: size.width * 0.35,
                    height: size.height * 0.15,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                height: size.height *0.13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: style.headerStyle3,
                    ),
                    Text(
                      product.price.toString() + " €",
                      style: style.textTheme
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      product.category,style: style.textTheme,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}