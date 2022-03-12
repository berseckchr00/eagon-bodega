import 'package:flutter/material.dart';

class AllocateAssignPage extends StatefulWidget {
  const AllocateAssignPage({Key key}) : super(key: key);

  @override
  _AllocateAssignPageState createState() => _AllocateAssignPageState();
}

class _AllocateAssignPageState extends State<AllocateAssignPage> {
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      //drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('EAGON Bodega'),
        centerTitle: true,
        backgroundColor: Colors.orange
        //leading: Icon(Icons.menu)
      ),
      body:    
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _createTextFormField(),
              _createSubmitButton()
            ],
          ),
        ),
    );
  }

 Widget _createTextFormField() {
   return TextFormField(
  // The validator receives the text that the user has entered.
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    },
  );
 }

  Widget _createSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (!_formKey.currentState.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
        },
        child: const Text('Submit'),
      ),
    );
  }
}