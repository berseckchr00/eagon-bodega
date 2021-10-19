//import 'package:eagon_bodega/src/pages/alert_dialog_page.dart';
import 'package:eagon_bodega/src/pages/allocate_assign_page.dart';
import 'package:eagon_bodega/src/pages/allocate_page.dart';
import 'package:eagon_bodega/src/pages/home_page.dart';
import 'package:eagon_bodega/src/pages/login_page.dart';
import 'package:eagon_bodega/src/pages/orders/orders_input_detail_page.dart';
import 'package:eagon_bodega/src/pages/orders/orders_input_page.dart';
import 'package:eagon_bodega/src/pages/orders_ot/orders_input_detail_page_ot.dart';
import 'package:eagon_bodega/src/pages/orders_ot/orders_input_page_ot.dart';
import 'package:eagon_bodega/src/pages/orders_page.dart';
import 'package:flutter/material.dart';


Map <String,WidgetBuilder> getApplicationRoutes(){ 


  return <String,WidgetBuilder>{
    '/login' : (context) => LoginPage(),
    '/home' : (BuildContext context) => HomePage(),
    '/orders' : (BuildContext context) => OrdersPage(),
    '/orders_input' : (BuildContext context) => OrdersInput(),
    '/orders_input_detail' : (BuildContext context) => OrderCreatePage(),
    '/orders_input_ot': (BuildContext conext) => OrdersInputOt(),
    '/orders_input_detail_ot': (BuildContext context) => OrderCreatePageOt(),
    /* '/reception' : (BuildContext context) => ReceptionPage(),
    '/reception_assign' : (BuildContext context) => ReceptionAssignPage(),
    '/reception_list' : (BuildContext context) => ReceptionOrderList(),
    '/reception_quantity' : (BuildContext context) => ReceptionQuantity(),
     */
    '/allocate' : (BuildContext context) => AllocatePage(),
    '/allocate_assign' : (BuildContext context) => AllocateAssignPage(),
    //'/sortable_list' : (BuildContext context) => SortableList(),
    '/logout' : (BuildContext context) => LoginPage(),
    //'/alert' : (BuildContext context) => StatefulDialog(),
    //'/login' : (BuildContext context) => LoginPage(),
  };
}