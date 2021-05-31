import 'package:eagon_bodega/src/pages/home_page.dart';
import 'package:eagon_bodega/src/routes/routes.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bodega Eagon',
      debugShowCheckedModeBanner: false,
      //home: LoginPage(),
      initialRoute: '/home',
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: ( BuildContext context ) => HomePage()
        );
      },
    );
  }
}