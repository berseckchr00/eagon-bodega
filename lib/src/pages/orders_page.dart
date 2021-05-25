import 'package:flutter/material.dart';

import 'package:eagon_bodega/src/pages/navdrawer_page.dart';

class OrdersPage extends StatelessWidget{
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
    return Row();
  }
}