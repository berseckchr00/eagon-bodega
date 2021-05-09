import 'package:flutter/material.dart';
import 'package:eagon_bodega/src/providers/menu_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EAGON Bodega'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: Icon(Icons.menu)
      ),
      body: _createLista(),
    );
  }

  Widget _createLista() {

    return FutureBuilder(
      future: menuProvider.loadMenu(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        print(snapshot);
        return ListView(
          children: _createItems(snapshot.data),
        );
      },
    );
  }

  List<Widget> _createItems(List<dynamic> data) {
    
    final List<Widget> opciones = [];
    print(data);
    data.forEach((opt) {

        final widgetTemp = ListTile(
          title: Text(opt['texto']),
          leading: Icon(Icons.visibility_off, color: Colors.red,),
          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.red),
          onTap: (){

          },
        );

        opciones
        ..add(widgetTemp)
        ..add(Divider());
        
    });

    return opciones;
  }
}