import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/core/database/database.dart';

class AddNewProduct extends StatelessWidget {
  final String data, documentID;
  AddNewProduct(this.data, this.documentID);

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add Product';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(appTitle),
        ),
        body: MyCustomForm(data, documentID),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  final String data, documentID;
  MyCustomForm(this.data, this.documentID);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  GlobalKey<FormBuilderState> _fbKey;
  @override
  void initState() {
    super.initState();
    _fbKey = GlobalKey<FormBuilderState>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {},
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  FormBuilderTextField(
                    maxLines: 1,
                    attribute: "name",
                    decoration: InputDecoration(labelText: "Name of Product"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    maxLines: 1,
                    attribute: "description",
                    decoration:
                        InputDecoration(labelText: "Description of Product"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    maxLines: 1,
                    attribute: "price",
                    decoration: InputDecoration(labelText: "Price of Product"),
                    validators: [
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(0.1),
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    maxLines: 1,
                    attribute: "quantity",
                    decoration:
                        InputDecoration(labelText: "Quantity of Product"),
                    validators: [
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(1),
                    ],
                  ),
                  FormBuilderTextField(
                    maxLines: 3,
                    attribute: "extras",
                    decoration: InputDecoration(
                        labelText:
                            "Extras follow pattern (name:price, name:price, ..)"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderCheckbox(
                    attribute: 'accept_terms',
                    label: Text(
                        "This Product add in that catagory: " + widget.data),
                    validators: [
                      FormBuilderValidators.requiredTrue(
                        errorText: "Recheck that data once again",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            MaterialButton(
              color: Colors.redAccent,
              child: Text("Add", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_fbKey.currentState.saveAndValidate()) {
                  String name = _fbKey.currentState.value['name'];
                  String price = _fbKey.currentState.value['price'].toString();
                  String quantity =
                      _fbKey.currentState.value['quantity'].toString();
                  String description = _fbKey.currentState.value['description'];
                  Map<String, int> myextras = new Map<String, int>();
                  String extras = _fbKey.currentState.value['extras'];
                  var list = extras.split(',');
                  try {
                    for (String i in list)
                      myextras[i.split(":")[0]] =
                          int.parse(i.split(":")[1]);
                    Map images = _fbKey.currentState.value['images'];
                    Fluttertoast.showToast(
                        msg: ' Please Wait ',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    await Database.setProducts(
                        context,
                        widget.data,
                        widget.documentID,
                        description,
                        myextras,
                        images,
                        name,
                        double.parse(price),
                        int.parse(quantity));
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: ' Extras formate is wrong ',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}
