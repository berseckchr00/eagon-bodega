//import 'package:eagon_bodega/src/pages/alert_dialog_page.dart';
import 'package:eagon_bodega/src/pages/home_page.dart';
import 'package:eagon_bodega/src/pages/login_page.dart';
import 'package:eagon_bodega/src/pages/orders_page.dart';
import 'package:eagon_bodega/src/pages/reception_assign_page.dart';
import 'package:eagon_bodega/src/pages/reception_list_page.dart';
import 'package:eagon_bodega/src/pages/reception_page.dart';
import 'package:eagon_bodega/src/pages/reception_quantity_page.dart';
import 'package:flutter/material.dart';


Map <String,WidgetBuilder> getApplicationRoutes(){ 


  return <String,WidgetBuilder>{
    '/login' : (context) => LoginPage(),
    '/home' : (BuildContext context) => HomePage(),
    '/orders' : (BuildContext context) => OrdersPage(),
    '/reception' : (BuildContext context) => ReceptionPage(),
    '/reception_assign' : (BuildContext context) => ReceptionAssignPage(),
    '/reception_list' : (BuildContext context) => ReceptionOrderList(),
    '/reception_quantity' : (BuildContext context) => ReceptionQuantity(),
    //'/sortable_list' : (BuildContext context) => SortableList(),
    '/logout' : (BuildContext context) => LoginPage(),
    //'/alert' : (BuildContext context) => StatefulDialog(),
    //'/login' : (BuildContext context) => LoginPage(),
  };
}