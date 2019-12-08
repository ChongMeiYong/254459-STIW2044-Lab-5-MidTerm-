import 'dart:async';
import 'package:my_express2/forgotpassword.dart';
import 'package:my_express2/loginpage.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

String urlReset = "http://alifmirzaandriyanto.com/mydriver/php/reset_password.php";

class ResetPassword extends StatefulWidget {
  final String  email;
  const ResetPassword({Key key, this.email}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState(); 
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  void initState(){
    super.initState();
  }

  @override 
  Widget build(BuildContext context){
    return WillPopScope( 
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar( 
          title: Text('Reset Password'),
          backgroundColor: Colors.blueGrey,
        ),
        body: SingleChildScrollView( 
          child: Container(
            padding: EdgeInsets.fromLTRB(40,20,40,20),
            child: ResetWidget(email: widget.email),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async { 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPassword(),
      )
    );
    return Future.value(false);
  }
}

class ResetWidget extends StatefulWidget {
  final String  email;
  const ResetWidget({Key key, this.email}) : super(key: key);

  @override 
  _ResetWidgetState createState() => _ResetWidgetState(email);
}

class _ResetWidgetState extends State<ResetWidget> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  final TextEditingController _tempwcontroller = TextEditingController();
  String _tempw = "";
  final TextEditingController _pwcontroller = TextEditingController();
  String _pw = "";
  String email;
  _ResetWidgetState(this.email);
  
  @override 
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Image.asset(
              'assets/images/forgotpw.png',
              scale: 1.5,
        ),
        SizedBox(
              height: 20,
        ),
             
        Text(widget.email), 
        Text("Please eneter you temporary password",style: TextStyle(fontSize: 18)),
        TextFormField(
          autovalidate: _validate,
          controller: _tempwcontroller,
          validator: validatePassword,
          decoration: InputDecoration(
            labelText: 'Temporary Password', icon: Icon(Icons.lock)
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 50,
        ),

        Text("Please enter your new password",style: TextStyle( fontSize: 15)),
        TextFormField(
          autovalidate: _validate,
          controller: _pwcontroller,
          validator: validatePassword,
          decoration: InputDecoration(
            labelText: 'Password', icon: Icon(Icons.lock)
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 10,
        ),

        MaterialButton( 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ), 
          minWidth: 300,
          height: 40,
          child: Text('Reset Password', style: TextStyle(fontSize: 18,)),
          color: Colors.blueAccent,
          textColor:  Colors.white,
          elevation: 15,
          onPressed: _onReset,
        ),
        SizedBox( 
          height: 20,
        ),
      ],
    );
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length <6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  void _onReset() {
    _tempw = _tempwcontroller.text;
    _pw = _pwcontroller.text;
    email = widget.email;
    if (_pw.length > 5) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Reset Password");
      pr.show();
      http.post(urlReset, body: {
        "email": email,
        "tempw": _tempw,
        "pw": _pw,
      }).then((res){
        print(res.statusCode);
        Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (res.body == "success"){
          pr.dismiss();
          Navigator.push(
            context, MaterialPageRoute(builder: (context)=> LoginPage())); 
        }else{
          pr.dismiss();
        }
      }).catchError((err){
          pr.dismiss();
          print(err);
    });
  } else{
    setState(() {
        _validate = true;
      });
      Toast.show("Please check your temporary password in your email.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onBackPress() {
    print('onBackpress from ResetPassword()');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage()
      )
    );
  }
}