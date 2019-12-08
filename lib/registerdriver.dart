import 'dart:io';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:my_express2/loginpage.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TextEditingController _uncontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _pwcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
final TextEditingController _radiuscontroller = TextEditingController();
String _name, _email, _password, _phone, _radius;

File _image;
String pathAsset = 'assets/images/profile.png';
String urlUpload = "http://alifmirzaandriyanto.com/mydriver/php/register_driver.php";

class RegisterDriver extends StatefulWidget {
  @override
  _RegisterDriverState createState() => _RegisterDriverState();
  const RegisterDriver({Key key, File image}) : super(key: key);
}

class _RegisterDriverState extends State<RegisterDriver> {
  @override
  void initState(){
    super.initState();
  }

  @override 
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue[300]));
    return WillPopScope( 
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar( 
          title: Text('New User Registration'),
          backgroundColor: Colors.blue[300],
        ),
        body: SingleChildScrollView( 
          child: Container(
            padding: EdgeInsets.fromLTRB(40,20,40,20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async { 
    _image = null;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      )
    );
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override 
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  @override 
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        GestureDetector( 
          onTap: _choose,
          child: Container( 
            width: 170,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage( 
                image: _image == null
                  ? AssetImage(pathAsset)
                  :FileImage(_image),
                fit: BoxFit.fill,
              )
            ),
          )
        ),
        SizedBox( 
          height: 10,
        ),
        Text('Click on the image above to take profile pic'),
        TextField( 
          controller: _uncontroller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration( 
            labelText: 'Name',
            icon: Icon(Icons.person),
          )
        ),

        TextField( 
          controller: _emcontroller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration( 
            labelText: 'Email',
            icon: Icon(Icons.email),
          )
        ),

        TextField( 
          controller: _pwcontroller,
          decoration: InputDecoration( 
            labelText: 'Password',
            icon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),

        TextField( 
          controller: _phcontroller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration( 
            labelText: 'Phone Number',
            icon: Icon(Icons.phone),
          )
        ),
        SizedBox( 
          height: 20,
        ),

        TextField(
          controller: _radiuscontroller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Radius',
            icon: Icon(Icons.blur_circular)
          )
        ),
        SizedBox( 
          height: 20,
        ),

        MaterialButton( 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)), 
          minWidth: 300,
          height: 40,
          child: Text('Sign Up', style: TextStyle(fontSize: 18,)),
          color: Colors.blueAccent,
          textColor:  Colors.white,
          elevation: 15,
          onPressed: _onSignUp,
        ),
        SizedBox( 
          height: 20,
        ),
        RichText(
          text: new TextSpan(
            text: 'Already Register? ',
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: 'Sign In',
                style: TextStyle(color: Colors.lightBlueAccent),
                recognizer: TapGestureRecognizer()..onTap = _onBackPress
              )
            ]
          )
        )
      ],
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
    //_image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onSignUp() {
    print('onRegister Button from RegisterDriver()');
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterDriver');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage()
      )
    );
  }

  void uploadData() {
    _name = _uncontroller.text;
    _email = _emcontroller.text;
    _password = _pwcontroller.text;
    _phone = _phcontroller.text;
    _radius = _radiuscontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5) &&
        (int.parse(_radius) < 30)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "radius": _radius,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _uncontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _pwcontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref(String email, String pass) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _pwcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', pass);
    print('Save pref $_email');
    print('Save pref $_password');
  }
}