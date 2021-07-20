import 'package:eagon_bodega/src/pages/login_page.dart';
import 'package:eagon_bodega/src/routes/routes.dart';
import 'package:eagon_bodega/src/shared_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
 
/*void main() async{
 
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());

}*/

void main() async{ 

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(
    MyApp()
  );

}
 
class MyApp extends StatelessWidget {
  //final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bodega Eagon',
      debugShowCheckedModeBanner: false,
      //home: LoginPage(),
      //initialRoute: prefs.ultimaPagina,
      initialRoute: '/login',
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: ( BuildContext context ) => LoginPage()
        );
      },
      /* theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.orange[800],
        accentColor: Colors.grey[600],

        // Define the default font family.
        //fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
       /*  textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.grey[800]),
          body1: TextStyle(color: Colors.grey[800]),
        ), */
      ), */
    );
  }
}