import 'package:flutter/material.dart';
//import 'package:componentes/src/pages/listViewStatic.dart';
//import 'package:componentes/src/pages/listViewDynamic.dart';
import 'package:eagon_bodega/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bodega Eagon',
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}