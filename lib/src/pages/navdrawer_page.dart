import 'package:eagon_bodega/src/shared_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

import 'package:eagon_bodega/src/providers/menu_provider.dart';
import 'package:eagon_bodega/src/utils/icons_string_utils.dart';

class NavDrawer extends StatelessWidget{

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _createLista()
    );
  }
  
  Widget _createLista() {

    return FutureBuilder(
      future: menuProvider.loadMenu(),
      initialData: [],
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        return ListView(
          children: _createItems(snapshot.data, context),
        );
      },
    );
  }

  List<Widget> _createItems(List<dynamic> data, BuildContext context) {
    
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

            /*final route = MaterialPageRoute(
              builder: (context) => HomePage()
            );*/

            //Navigator.push(context, route);
            if(opt['ruta'] == '/logout') {
              prefs.ciSession = '';
              Navigator.of(context).pushNamedAndRemoveUntil(opt['ruta'] , (Route<dynamic> route) => false);
            }
            else{
              Navigator.pushNamed(context, opt['ruta']);
            }
            //Navigator.pushReplacementNamed(context, opt['ruta']);
          },
        );

        opciones.add(widgetTemp);

        if(opt['divider']){
          opciones.add(Divider());
        }
        
        
    });

    return opciones;
  }
}