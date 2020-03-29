import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String category;
  String categoryID;
  double price;
  String name;
  String description;
  int quantity;
  List<String> images;
  Map<String, double> extras;
  bool liked;
  bool isInCart;

  Product from(DocumentSnapshot ds) {
    category = ds.data['category'];
    categoryID = ds.data['categoryID'];
    if (ds.data['price'] is String) {
      price = double.parse(ds.data['price']);
      print("String:${ds.data['price']}");
    } else if (ds.data['price'] is double) {
      print("double:${ds.data['price']}");
      images = (ds.data['images'] as List<dynamic>).cast();
      extras = (ds.data['extras'] as Map<dynamic, dynamic>).cast();
      price = ds.data['price'];
    }
    name = ds.data['name'];
    quantity = 1;
    id = ds.documentID;
    liked = false;
//    print(category);
//    print(categoryID);
//    print(price);
//    print(quantity);
//    print(images);
//    print(extras);
//    print(name);
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'categoryID': categoryID,
      'price': price,
      'name': name,
    };
  }
}
