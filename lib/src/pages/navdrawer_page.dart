import 'package:flutter/material.dart';

import 'package:eagon_bodega/src/providers/menu_provider.dart';
import 'package:eagon_bodega/src/utils/icons_string_utils.dart';

class NavDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _createLista()
    );
  }
  
  Widget _createLista() {

    return FutureBuilder(
      future: menuProvider.loadMenu(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        return ListView(
          children: _createItems(snapshot.data),
        );
      },
    );
  }

  List<Widget> _createItems(List<dynamic> data) {
    
    final List<Widget> opciones = [];
    
    final drawerHead =  DrawerHeader(
      child: Text(
        'Menú',
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
      decoration: BoxDecoration(
          color: Colors.orange,
          // image: DecorationImage(
          //     fit: BoxFit.fill,
          //     image: AssetImage('assets/images/LOGO-EAGON_gris-350x78.png')
          // )
      ),
    );

    opciones
    ..add(drawerHead)
    ..add(Divider());
    data.forEach((opt) {

        final widgetTemp = ListTile(
          title: Text(opt['texto']),
          leading: getIconByString(opt['icon']),
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