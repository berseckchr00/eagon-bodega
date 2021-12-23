import 'dart:convert';

import 'package:eagon_bodega/src/models/Timbre.dart';
import 'package:xml2json/xml2json.dart';
import 'package:flutter/material.dart';

class ReceptionPage extends StatelessWidget {
  const ReceptionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const ReceptionSearch(),
      ),
    );
  }
}

// Create a Form widget.
class ReceptionSearch extends StatefulWidget {
  const ReceptionSearch({Key key}) : super(key: key);

  @override
  ReceptionSearchState createState() {
    return ReceptionSearchState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ReceptionSearchState extends State<ReceptionSearch> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<ReceptionSearchState>.
  final _formKey = GlobalKey<FormState>();
  Timbre timbre = new Timbre();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onFieldSubmitted: (String value) {
              _parseXML2Json(value);
            },
          ),
          Container(
            padding: const EdgeInsets.only(left: 150.0, top: 40.0),
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
          ),
        ],
      ),
    );
  }

  void _parseXML2Json(String value) {
    value = value.replaceFirst(
        '<TED xmlns="http://www.sii.cl/SiiDte"version="1.0">', '<TED>');

    print(value);

    final myTransformer = Xml2Json();

    myTransformer.parse(value);

    String json = myTransformer.toParker();

    Map<String, dynamic> tmbr = jsonDecode(json);
    timbre = Timbre.fromJson(tmbr);

    print(timbre);
  }
}
