import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/admin/orders/style.dart';
import 'package:food_delivery_app/core/database/database.dart';

class MyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Orders';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: Database.getOrdersDetailsList(),
      builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                height: 45,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                ),
              );
            default:
              List<DocumentSnapshot> list = null;
//                  snapshot.data.documents.reversed.toList();
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 13, 0, 13),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                      child: Card(
                        margin: EdgeInsets.all(1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.0)),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              
                              SizedBox(height: 8),
                              SizedBox(height: 8),
                              MySeparator(
                                color: Colors.grey,
                              ),
                              SizedBox(height: 15),
                              list[index].data["status"] == "0"
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          InkWell(
                                            child: Text(
                                              "Accept",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onTap: () {
                                              Firestore.instance
                                                  .collection("Orders")
                                                  .document(
                                                      list[index].documentID)
                                                  .updateData({"status": "1"});
                                              setState(() {});
                                            },
                                          ),
                                          InkWell(
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onTap: () {
                                              Firestore.instance
                                                  .collection("Orders")
                                                  .document(
                                                      list[index].documentID)
                                                  .updateData({"status": "2"});
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : list[index].data["status"] == "1"
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              InkWell(
                                                child: Text(
                                                  "Completed",
                                                  style: TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onTap: () {
                                                  Firestore.instance
                                                      .collection("Orders")
                                                      .document(list[index]
                                                          .documentID)
                                                      .updateData(
                                                          {"status": "3"});
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      : list[index].data["status"] == "3"
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                    child: Text(
                                                      "Deleat",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onTap: () {
                                                      Firestore.instance
                                                          .collection("Orders")
                                                          .document(list[index]
                                                              .documentID)
                                                          .delete();

                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                      child: Text(
                                                        "Deleat",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onTap: () {
                                                        Firestore.instance
                                                            .collection(
                                                                "Orders")
                                                            .document(
                                                                list[index]
                                                                    .documentID)
                                                            .delete();

                                                        setState(() {});
                                                      }),
                                                ],
                                              ),
                                            )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        }
      },
    );
  }
}
