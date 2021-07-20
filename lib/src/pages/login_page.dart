import 'dart:async';

import 'package:eagon_bodega/src/models/user_model.dart';
import 'package:eagon_bodega/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget{
  
  @override
  createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>
  with TickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'user': null, 'password': null};

  UserModel user = new UserModel();
  UserProvider userProvider = new UserProvider();

  bool submitting = false;

  @override
  void initState() { 
    super.initState();
  }

  void _toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('EAGON Bodega'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
      ),
      body:  !submitting
            ? _createForm(context)
            : const Center(child: const CircularProgressIndicator())
    );
  }

  Widget _createForm(BuildContext context){
  return Form(
    key: _formKey,
    child :
    SingleChildScrollView(
      child :
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                  child: 
                    Image(image: AssetImage('assets/images/LOGO-EAGON_gris-350x78.png'))
                  ),
              ),
            ),
           Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child:
                _createUserInput()
           ),      
          Padding(
              padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: _createPasswordInput()
          ),
          Padding(
              padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
              child:_createSubmitButton(context)
          )
        ]
      )
    )
  );  
}

  Widget _createUserInput(){
    return TextFormField(
      initialValue: user.idUser,
      style: TextStyle(color: Colors.black, fontSize: 20.0),
      decoration: const InputDecoration(
        hintText: 'Ingresa tu usuario',
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
      ),
      validator: (value){
        if(value.isEmpty){
          return 'Usuario Inválido';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['user'] = value;
        user.idUser = value;
        user.user = value;
      },
    );
  }

  Widget _createPasswordInput(){
    return TextFormField(
      initialValue: user.passWord,
      style: TextStyle(color: Colors.black, fontSize: 20.0),
      decoration: const InputDecoration(
        hintText: 'Ingresa tu clave',
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
      ),
      validator: (value){
        if(value.isEmpty){
          return 'Clave Inválida';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
        user.passWord = value;
        user.pass = value;
      },
      obscureText: true
    );
  }

  Widget _createSubmitButton(BuildContext context){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.orange
      ),
      onPressed: (){
          if (_formKey.currentState.validate()){
            _submitForm(context);
          }
        }, 
      child: Text('Ingresar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )
      );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final Future<UserModel> generatedUser = userProvider.getUserLogin(user);
      
      _toggleSubmitState();
      generatedUser
      .then((value) => {

        if (value != null){
          if (value.status == 1) {
            //controller.dispose(),
            Timer(Duration(seconds: 1), () {
              _toggleSubmitState();
              // 5 seconds over, navigate to Page2.
              //Navigator.pushNamed(context, '/home');
              Navigator.pushNamed(context, '/reception_list');
            })            
          }else{
            //controller.dispose(),
            
            _toggleSubmitState(),
            Fluttertoast.showToast(
              msg: "Error al iniciar",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
            )
          }
        }else{
          //controller.dispose(),
          
          _toggleSubmitState(),
          Fluttertoast.showToast(
              msg: "Error al iniciar",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
            )
        }
      });
      //Navigator.pushNamed(context, '/home');

    }
  }
}