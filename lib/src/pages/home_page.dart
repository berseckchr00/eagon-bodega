import 'package:eagon_bodega/src/pages/navdrawer_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('EAGON Bodega'),
        centerTitle: true,
        backgroundColor: Colors.orange
        //leading: Icon(Icons.menu)
      ),
      //body: _createLista(),
      body: _homeView(),
    );
  }

  Widget _homeView(){
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        _pendingReception(),
        _pendingReception(),
        _pendingReception(),
        Divider(color: Colors.redAccent,),
        _pendingDelivery(),
        _pendingDelivery()
      ],
    );
  }
  
}

Widget _pendingReception() {
  return Card(
    child: Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.online_prediction_sharp, color: Colors.amberAccent),
          title: Text('Recepcion N° 123432'),
          subtitle: Text('Proveedor : EAGON LAUTARO \nFecha Emisión : 01-01-2021'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: (){}, 
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: (){}, 
              child: Text('Recepcionar')
            )
          ],
        )
      ],
    ),
  );
}

Widget _pendingDelivery() {
  return Card(
    child: Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.delivery_dining, color: Colors.deepOrange),
          title: Text('Entrega N° 123432'),
          subtitle: Text('Usuario : Juan C. Torres \nFecha Entrega : 01-01-2021'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: (){}, 
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: (){}, 
              child: Text('Entregar')
            )
          ],
        )
      ],
    ),
  );
}