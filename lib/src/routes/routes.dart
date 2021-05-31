import 'package:eagon_bodega/src/pages/home_page.dart';
import 'package:eagon_bodega/src/pages/login_page.dart';
import 'package:eagon_bodega/src/pages/orders_page.dart';
import 'package:flutter/material.dart';


Map <String,WidgetBuilder> getApplicationRoutes(){ 


  return <String,WidgetBuilder>{
    '/login' : (BuildContext context) => LoginPage(),
    '/home' : (BuildContext context) => HomePage(),
    '/orders' : (BuildContext context) => OrdersPage(),
    '/reception' : (BuildContext context) => OrdersPage(),
    //'/login' : (BuildContext context) => LoginPage(),
  };
}