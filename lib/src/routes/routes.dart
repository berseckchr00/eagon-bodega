import 'package:eagon_bodega/src/pages/allocation/allocation_dte.dart';
import 'package:eagon_bodega/src/pages/allocation/allocation_list_page.dart';
import 'package:eagon_bodega/src/pages/allocation/allocaton_page.dart';
import 'package:eagon_bodega/src/pages/home_page_blank.dart';
import 'package:eagon_bodega/src/pages/login_page.dart';
import 'package:eagon_bodega/src/pages/orders/orders_input_detail_page.dart';
import 'package:eagon_bodega/src/pages/orders/orders_input_page.dart';
import 'package:eagon_bodega/src/pages/orders_ot/orders_input_detail_page_ot.dart';
import 'package:eagon_bodega/src/pages/orders_ot/orders_input_page_ot.dart';
import 'package:eagon_bodega/src/pages/orders_page.dart';
import 'package:eagon_bodega/src/pages/receptions/reception_dte.dart';
import 'package:eagon_bodega/src/pages/receptions/reception_list_page.dart';
import 'package:eagon_bodega/src/pages/receptions/resume/reception_resumen.dart';
import 'package:eagon_bodega/src/pages/receptions/receptions_page.dart';
import 'package:eagon_bodega/src/pages/receptions/reception_search.dart';

import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (context) => LoginPage(),
    //'/home': (BuildContext context) => HomePage(),
    '/home_blank': (BuildContext context) => HomePage(),
    '/orders': (BuildContext context) => OrdersPage(),
    '/orders_input': (BuildContext context) => OrdersInput(),
    '/orders_input_detail': (BuildContext context) => OrderCreatePage(),
    '/orders_input_ot': (BuildContext conext) => OrdersInputOt(),
    '/orders_input_detail_ot': (BuildContext context) => OrderCreatePageOt(),
    '/reception': (BuildContext context) => ReceptionsPage(),
    '/reception_dte': (BuildContext context) => ReceptionDtePage(),
    /*'/reception_assign' : (BuildContext context) => ReceptionAssignPage(),*/
    '/reception_list': (BuildContext context) => ReceptionOrderList(),
    '/reception_resumen': (BuildContext context) => ReceptionResumen(),
    /*
    '/reception_quantity' : (BuildContext context) => ReceptionQuantity(),
     */
    //'/sortable_list' : (BuildContext context) => SortableList(),
    '/logout': (BuildContext context) => LoginPage(),
    '/reception_search': (BuildContext context) => ReceptionPage(),
    //'/alert' : (BuildContext context) => StatefulDialog(),
    //'/login' : (BuildContext context) => LoginPage(),
    '/allocate': (BuildContext context) => AllocationPage(),
    '/allocation_dte': (BuildContext context) => AllocationDtePage(),
    '/allocation_list': (BuildContext context) => AllocationOrderList(),
  };
}
