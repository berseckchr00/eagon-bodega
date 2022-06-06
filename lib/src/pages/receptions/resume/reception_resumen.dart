import 'dart:convert';

import 'package:flutter/material.dart';

class fullArgumentsResumen {
  var jsonData;
  fullArgumentsResumen(this.jsonData);
}

class ReceptionResumen extends StatefulWidget {
  ReceptionResumen({Key key}) : super(key: key);

  @override
  State<ReceptionResumen> createState() => _ReceptionResumenState();
}

class _ReceptionResumenState extends State<ReceptionResumen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as fullArgumentsResumen;
    var _reception = args.jsonData;

    print(jsonDecode(_reception));
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen Recepción'),
        backgroundColor: Colors.orange,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.orange),
            onPressed: () {
              Navigator.pushNamed(context, '/reception');
            },
            child: Text("Finalizar"),
          ),
        ],
      ),
      body: _createFrame(jsonDecode(_reception)),
    );
  }

  _createFrame(Map<String, dynamic> data) {
    var _list = data.values.toList();
    return Container(
        child: Column(children: [
      Center(child: _createHead(_list[0])),
      new Expanded(child: _createDetailBody(_list[1])),
    ]));
  }

  _createHead(Map<String, dynamic> data) {
    var _list = data.values.toList();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text('Datos Documento'),
            subtitle: Text('Folio : ' +
                _list[0] +
                '\nFecha Emisión : ' +
                _list[5] +
                '\nRut Proveedor :' +
                _list[1] +
                ' \nNúmero OC : ' +
                _list[2]),
            leading: Icon(Icons.home),
          )
        ],
      ),
    );
  }

  _createDetailBody(List<dynamic> data) {
    return new ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> line = data[index];
        var l = line.values.toList();
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text('Producto ' + (index + 1).toString()),
              subtitle: new Text(line['glosa_proveedor'] +
                  '\ncantidad: ' +
                  line['cantidad'] +
                  '\ncodigo oc:' +
                  line['oc_glosa']),
            ),
            new Divider(
              height: 2.0,
            ),
          ],
        );
      },
    );
  }
}
