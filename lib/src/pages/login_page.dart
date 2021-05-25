import 'package:eagon_bodega/src/models/user_model.dart';
import 'package:eagon_bodega/src/providers/users_provider.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  
  @override
  createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'user': null, 'password': null};

  UserModel user = new UserModel();
  UserProvider userProvider = new UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('EAGON Bodega'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: _createForm(context)
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
      print(_formData);

      final Future<UserModel> generatedUser = userProvider.getUserLogin(user);

      generatedUser.then((value) => {
        if (value.status == 1) {
          Navigator.pushNamed(context, '/home')
        }
      });
      //Navigator.pushNamed(context, '/home');

    }
  }
}