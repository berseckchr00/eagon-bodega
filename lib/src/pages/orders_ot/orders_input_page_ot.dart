import 'dart:convert';

import 'package:eagon_bodega/src/forms/orders_input_form.dart';
import 'package:eagon_bodega/src/models/ccosto_model.dart';
import 'package:eagon_bodega/src/models/employee_model.dart';
import 'package:eagon_bodega/src/models/item_cost_model.dart';
import 'package:eagon_bodega/src/models/machine_model.dart';
import 'package:eagon_bodega/src/models/warehouse_model.dart' as warehouse;
import 'package:eagon_bodega/src/providers/outgoing_provider.dart';
import 'package:eagon_bodega/src/providers/warehause_provider.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:json_to_form/json_schema.dart';

class OrdersInputOt extends StatefulWidget {
  OrdersInputOt({Key key}) : super(key: key);

  @override
  _OrdersInputOtState createState() => _OrdersInputOtState();
}

class _OrdersInputOtState extends State<OrdersInputOt> {

  OrderInputForm orderInputField = new OrderInputForm();
  WareHouseProvider wareHouseProvider = new WareHouseProvider();
  OutgoingProvider outgoingProvider = new OutgoingProvider(); 
  Map<String,dynamic> responseOt = new Map<String,dynamic>();
  List<warehouse.Data> itemsWareHouse = new List<warehouse.Data>();
  List<EmployeeModel> employeeList = new List<EmployeeModel>();
  List<CCostoModel> ccostList = new List<CCostoModel>();
  List<MachineModel> machineList = new List<MachineModel>();
  List<ItemCostModel> itemCostList = new List<ItemCostModel>();

  Map<String, dynamic> itemForm = new Map<String, dynamic>();

  Map keyboardTypes = {
    "number": TextInputType.number,
  };
  dynamic response;

  @override
  void initState() {
    ///setState(() {
      //_toggleSubmitState();
      super.initState();/* 
      getOtData().then((value) => {
        setState(() {
          responseOt = value;
        })
      }); */
      /* 
      getEmployeeList().then((value) => {
        setState(() {
          employeeList = value;
        })
      }); */
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context).settings.arguments;

    getOtData(args).then((value) => {
        setState(() {
          responseOt = value;
        })
    });

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("Generación de Pedido"),
      ),
      body: (itemsWareHouse.isEmpty)? const Center(child: const CircularProgressIndicator()):
        new SingleChildScrollView(
        child: new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new Column(children: <Widget>[
            new Container(
              child: new Text(
                "Datos Generales",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 10.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField(itemsWareHouse[0].nombre, "Bodega")
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField(employeeList[0].employe, "Empleado")
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField(machineList[0].machine, "Maquina")
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField(ccostList[0].cCostoCode, "Centro Costo")
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField(itemCostList[0].description, "Item de Gasto")
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                //primary: Colors.orange
              ),
              onPressed: (){
                Navigator.pushNamed(context, "/orders_input_detail_ot", arguments: responseOt);
              },
              child: Text('Ingresar Detalle',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
              ),
          ]),
        ),
      ),
    );
  }

  Future<Map<String,dynamic>> getOtData(String otNumber) async {    
    Map<String,dynamic> response = await outgoingProvider.getOtData(otNumber);
    return response;
  }

  Widget _createTextFormField(String text, String label) {
   return TextFormField(
  // The validator receives the text that the user has entered.
    decoration: InputDecoration(
      labelText: label,
        hintStyle: TextStyle(
          color: Colors.orange.shade300
        ),
        labelStyle: TextStyle(
          color: Colors.orange.shade900
        ), 
    ),
    initialValue: text,
    enabled: false,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    },
  );
 }

}