import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  
  @override
  createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'user': null, 'password': null};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('EAGON Bodega'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: _createForm()
    );
  }

Widget _createForm(){
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
              child:_createSubmitButton()
          )
        ]
      )
    )
  );  
}

  Widget _createUserInput(){
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 20.0),
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
      },
    );
  }

  Widget _createPasswordInput(){
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 20.0),
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
      },
      obscureText: true
    );
  }

  Widget _createSubmitButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.orange
      ),
      onPressed: (){
          if (_formKey.currentState.validate()){
            _submitForm();
          }
        }, 
      child: Text('Ingresar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )
      );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_formData);
    }
  }
}