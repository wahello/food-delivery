
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/models/ShoppingCart.dart';
import 'package:food_delivery_app/core/models/category.dart';
import 'package:food_delivery_app/core/models/product.dart';

class Database{
  static Database _instance;
  String uid;
  Firestore db;

  Database(String uid){
    db=Firestore.instance;
    this.uid=uid;
  }

  static Database getInstance({String uid}){
    if(_instance==null)
      _instance=new Database(uid);

    return _instance;
  }

  static Future<void> writeToDocument(String path,Map<String,dynamic> map)async{
    await Firestore.instance.document(path).setData(map);
    return null;
  }

  static Future<void> writeUserDetails(Map<String,dynamic> user,{String uid})async{
    if(uid==null){
      FirebaseUser user=await Auth().currentUser();
      uid=user.uid;
    }
    await Firestore.instance.collection("users").document(uid).setData(user,merge: true);
    return null;
  }
  
  static Future<Map<String,dynamic>> readUserDetails(){
    return Auth().currentUser().then((user){
      return Firestore.instance.collection("users").document(user.uid).get().then((snap){
        snap.data.addAll({'uid':user.uid});
        return snap.data;
      });
    });
  }

  Future<List<Category>> getCategories(){
    return db.collection("categories").getDocuments(source: Source.serverAndCache).then((val){
      List<Category> categories=new List();
      for(var doc in val.documents){
        categories.add(Category().from(doc));
      }
      return categories;
    });
  }
//
//  Future<List<Product>> getLatestMenuItems(){
//    return db.collection("products").getDocuments(source: Source.serverAndCache).then((val){
//      List<Product> products=new List();
////      Map<String,dynamic> map;
//      for(var doc in val.documents){
////        map=doc.data;
//        products.add(Product().from(doc));
//      }
////      for(int i=0;i<50;i++){
////        db.collection("products").document().setData(map);
////      }
//      return products;
//    });
//  }

  void getCardToken(){
    //TODO:Implement

  }

  Future<void> setCardToken(Map<String,dynamic> token)async{
    await db.collection("stripe_customers").document(uid).collection("tokens").document().setData(token,merge: false);
    return;
  }

  void deleteProductWithId(String id){
    db.collection('products').document(id).delete();
  }

  Future<List<DocumentSnapshot>> getAllProducts()async{
    print("getAllProducts");
//    if(allProducts!=null)return allProducts;
    return db.collection("products").getDocuments(source: Source.serverAndCache).then((val){
      return val.documents;
    });
  }

  void addChargeSource(double amount) {
    db.collection('stripe_customers/${uid}/charges').document().setData({'amount':amount});
  }

  Stream<QuerySnapshot> listenForSources() {
    return db.collection('stripe_customers').document(uid).collection("sources").snapshots();
  }

  Stream<DocumentSnapshot> listenForPaymentConfirmation(){
    return db.collection('orders').document(uid).snapshots();
  }

  Future addOrder(ShoppingCart shoppingCart) async{
    List<String> productList=[];
    List<int> quantities=[];

    for(Product p in shoppingCart.getProductsList()){
      productList.add(p.id);
      quantities.add(p.quantity);
    }

    Map<String,dynamic> shoppingDetails={
      'productList':productList,
      'quantities':quantities,
    };
    await db.collection('orders').document(uid).collection('requests').document().setData(shoppingDetails);
    return;
  }

  void clearOrderStatus() {
    db.collection('orders').document(uid).setData({'status':null},merge: true);
  }

  Stream<QuerySnapshot> listenForErrors() {
    return db.collection('stripe_customers').document(uid).collection("tokens").snapshots();
  }
}