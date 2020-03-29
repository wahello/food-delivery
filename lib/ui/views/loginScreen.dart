import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/core/Auth.dart';
import 'package:food_delivery_app/core/database/database.dart';
import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';
import 'package:food_delivery_app/ui/views/Login_staggeredAnimation/staggeredAnimation.dart';
import '../shared/custom_social_icons.dart';
import 'mainHome.dart';
import 'main_home_wrapper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  var loading=false;
  Auth authService=Auth();


  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();


  void signInWithGoogle() {
    authService.signInWithGoogle().then((uid){
      if(uid==null)return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHome(),
        ),
      );
    });
  }

  bool validInput(String email,String password){
    if(email.isEmpty){
      ToastCall.showToast("Email is Empty");
      return false;
    }if(password.isEmpty){
      ToastCall.showToast("Email is Empty");
      return false;
    }if(password.length<6){
      ToastCall.showToast("Password length is too Short");
      return false;
    }
    return true;
  }

  void resetPassword(String email){
    if(email.isEmpty){
      ToastCall.showToast("Email is empty");
      return;
    }
    try {
      authService.resetPassword(email);
      ToastCall.showToast("Email sent to reset Password");
    } on Exception catch(_){
      ToastCall.showToast("Failed To Reset Password");
    }
  }

  void enableLoading(){
    setState(() {
      loading=true;
    });
  }

  void disableLoading(){
    setState(() {
      loading=false;
    });
  }

  void performLogin(String email,String password)async{
    print("Email$email, Password$password");
    enableLoading();
    if(!validInput(email,password))return;
    try {
      authService.signInWithEmailAndPassword(email, password).then((uid){
        if(uid==null){
          disableLoading();
          return;
        }
        authService.isEmailVerified().then((isVerified)async{
          print("isVerified$isVerified");
          if(isVerified){
            Database.getInstance(uid:uid);
            ProductList productList=await ProductList().getProductsList();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainHomeWrapper(productList: productList,),
              ),
            );
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => MainHome(),
//            ),
//          );
          }else{
            disableLoading();
            ToastCall.showToast("Email Not Verified");
            authService.signOut();
          }
        });
      }).catchError((err){
        var msg="An Invalid Error Has Occured";
        if(err is AuthException || err is PlatformException)
          msg=err.message;
        disableLoading();
        Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } on Exception catch(ex){
      disableLoading();
      var msg="An Invalid Error Occured";
      if(ex is PlatformException){
        msg=ex.message;
      }else if(ex is AuthException){
        msg=ex.message;
      }

      print(ex);
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
      );
    }
  }


  @override
  void initState() {
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

    super.initState();
  }

  Future<Null> _playAnimation() async {
    print("onLoginButtonClick");
    await _loginButtonController.reset() ;
    try {
      await _loginButtonController.forward().whenComplete(() async{
        setState(() {
          animationStatus = 0 ;
        });
      });
      //await _loginButtonController.reverse();
    } on TickerCanceled {
      print("onTickerCanceled");
    }
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.05), BlendMode.dstATop),
                image: AssetImage('assets/home_background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
//              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: MediaQuery.of(context).size.height > 600
                              ? MediaQuery.of(context).size.height * 0.1
                              : MediaQuery.of(context).size.height * 0.05),
                      child: Center(
                        child: Image.asset(
                          "assets/icons&splashs/Asset 51.png",
                          color: Theme.of(context).primaryColor,
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              "EMAIL",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: emailController,
                              obscureText: false,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'restaurantapp@live.com',
                                hintStyle:
                                    TextStyle(color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              "PASSWORD",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '*********',
                                hintStyle:
                                    TextStyle(color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: FlatButton(
                            child: Text(
                              "RECUPERA PASSWORD?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            onPressed: (){
                              resetPassword(emailController.text);
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(

                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 20.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration:
                                      BoxDecoration(border: Border.all(width: 0.25)),
                                ),
                              ),
                              Text(
                                "CONNETTITI CON",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration:
                                      BoxDecoration(border: Border.all(width: 0.25)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          color: Color(0Xff3B5998),
                                          onPressed: () => {},
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: FlatButton(
                                                    onPressed: () {},
                                                    padding: EdgeInsets.only(
                                                      top: 20.0,
                                                      bottom: 20.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Icon(
                                                          CustomSocial.facebook,
                                                          color: Colors.white,
                                                          size: 15.0,
                                                        ),
                                                        Text(
                                                          "FACEBOOK",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 8.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          color: Color(0Xffdb3236),
                                          onPressed: () => {},
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: FlatButton(
                                                    onPressed: (){
                                                      signInWithGoogle();
                                                    },
                                                    padding: EdgeInsets.only(
                                                      top: 20.0,
                                                      bottom: 20.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Icon(
                                                          CustomSocial.google,
                                                          color: Colors.white,
                                                          size: 15.0,
                                                        ),
                                                        Text(
                                                          "GOOGLE",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05,)
                      ],
                    ),
                  ],
                ),
                animationStatus == 0
                    ? Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.95 - 180),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 30.0, right: 30.0 ),
                        //alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {

                                performLogin(emailController.text, passwordController.text);

//                            setState(() {
//                              animationStatus = 1;
//                            });
//                            _playAnimation();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "LOGIN",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      )
                    : StaggerAnimation(buttonController: _loginButtonController.view,screenSize: MediaQuery.of(context).size,),
                loading?Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black12,
                  child: Center(child: CircularProgressIndicator()),
                ):Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
