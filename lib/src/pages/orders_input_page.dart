import 'dart:convert';

import 'package:eagon_bodega/src/forms/orders_input_form.dart';
import 'package:eagon_bodega/src/models/employee_model.dart';
import 'package:eagon_bodega/src/models/warehouse_model.dart';
import 'package:eagon_bodega/src/providers/employee_provider.dart';
import 'package:eagon_bodega/src/providers/warehause_provider.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form/json_schema.dart';

class OrdersInput extends StatefulWidget {
  OrdersInput({Key key}) : super(key: key);

  @override
  _OrdersInputState createState() => _OrdersInputState();
}

class _OrdersInputState extends State<OrdersInput> {

  OrderInputForm orderInputField = new OrderInputForm();
  WareHouseProvider wareHouseProvider = new WareHouseProvider();
  EmployeeProvider employeeProvider = new EmployeeProvider(); 
  List<String> itemsWareHouse = new List<String>();
  List<EmployeeModel> employeeList = new List<EmployeeModel>();

  Map keyboardTypes = {
    "number": TextInputType.number,
  };
  dynamic response;

  @override
  void initState() {
    ///setState(() {
      //_toggleSubmitState();
      super.initState();
      getWareHouseList().then((value) => {
        setState(() {
          itemsWareHouse = value;
        })
      });
      getEmployeeList().then((value) => {
        setState(() {
          employeeList = value;
        })
      });
  }

  @override
  Widget build(BuildContext context) {

    
    String form = orderInputField.fields;
    Map decorations = orderInputField.decorations;

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
              child: createDropdownWareHouse()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: createDropdownEmploye()),
            new JsonSchema(
              decorations: decorations,
              //keyboardTypes: keyboardTypes,
              form: form,
              onChanged: (dynamic response) {
                print(jsonEncode(response));
                this.response = response;
              },
              actionSave: (data) {

                Navigator.pushNamed(context, "/orders_input_detail");
              },
              buttonSave: new Container(
                height: 40.0,
                color: Colors.blueAccent,
                child: Center(
                  child: Text("Ingresar Detalle",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<List<String>> getWareHouseList() async {    
    WareHouseModel wareHouse = await wareHouseProvider.getWareHouseList();
    
    List<String> items = new List<String>();
    wareHouse.data.forEach((element) {
      items.add(element.nombre);
    });
    
    print(items);
    return items;
  }

  Future<List<EmployeeModel>> getEmployeeList() async{
    return await employeeProvider.getEmployeeList();
    //print(employeeList.toString());
  }

  Widget createDropdownWareHouse(){
    return  FindDropdown(
      items: itemsWareHouse,
      label: "Bodega",
      searchBoxDecoration: InputDecoration(
        labelText: "Bodega",
        prefixIcon: Icon(Icons.info_outline),
        border: OutlineInputBorder()
      ),
      autofocus: true,
      showSearchBox: true,
      labelStyle: TextStyle(
        color: Colors.red
      ),
      searchHint: "Selecciona una Bodega",
      onChanged: (String item) => print(item),
      selectedItem: "Busqueda de Bodega",
      validate: (String item) {
        if (item == null)
          return "Campo Requerido";
        else
          return null; //return null to "no error"
      },
    );
  }

  Widget createDropdownEmploye(){
    return  FindDropdown<EmployeeModel>(
      items: employeeList,
      label: "Empleado",
      searchBoxDecoration: InputDecoration(
        labelText: "Empleado",
        prefixIcon: Icon(Icons.info_outline),
        border: OutlineInputBorder()
      ),
      autofocus: true,
      showSearchBox: true,
      labelStyle: TextStyle(
        color: Colors.red
      ),
      searchHint: "Selecciona un empleado",
      onChanged: (EmployeeModel item) => print(item.employe),
      //selectedItem: "Busqueda de empleado",
      validate: (EmployeeModel item) {
        if (item == null)
          return "Campo Requerido";
        else
          return null; //return null to "no error"
      },
    );
  }

  Widget createDropdownCCost(){

  }

  Widget createDropdownItemCost(){

  }
}