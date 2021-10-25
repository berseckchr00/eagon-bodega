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

class OrdersInput extends StatefulWidget {
  OrdersInput({Key key}) : super(key: key);

  @override
  _OrdersInputState createState() => _OrdersInputState();
}

class _OrdersInputState extends State<OrdersInput> {

  OrderInputForm orderInputField = new OrderInputForm();
  WareHouseProvider wareHouseProvider = new WareHouseProvider();
  OutgoingProvider outgoingProvider = new OutgoingProvider(); 
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
              child: _loadComponent('warehause')
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _loadComponent('employee')
            ),
            /* Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _loadComponent('machine')
            ), */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _loadComponent('ccost')
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _loadComponent('itemcost')
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                //primary: Colors.orange
              ),
              onPressed: (){
                itemForm.remove('ID_MAQUINA');
                itemForm.addAll({'ID_MAQUINA': 0});
                if(!_validateForm()){
                  Fluttertoast.showToast(
                    msg: "Faltan elementos por cargar",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                  );
                }else{
                  Navigator.pushNamed(context, "/orders_input_detail", arguments: itemForm);
                }
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

  Future<List<warehouse.Data>> getWareHouseList() async {    
    warehouse.WareHouseModel wareHouse = await wareHouseProvider.getWareHouseList();
    
    /* List<String> items = new List<String>();
    wareHouse.data.forEach((element) {
      items.add(element.nombre);
    }); */
    return wareHouse.data;
  }

  Future<List<EmployeeModel>> getEmployeeList() async{
    return await outgoingProvider.getEmployeeList();
    //print(employeeList.toString());
  }

  Future<List<CCostoModel>> getCCostList(idDepartment) async{
    return await outgoingProvider.getCCostList(idDepartment);
    //print(employeeList.toString());
  }

  Future<List<MachineModel>> getMachineList(idDepartment) async{
    return await outgoingProvider.getMachineList(idDepartment);
    //print(employeeList.toString());
  }

  Future<List<ItemCostModel>> getItemCostList(idDepartment) async{
    return await outgoingProvider.getItemCostList(idDepartment);
    //print(employeeList.toString());
  }

  Widget createDropdownWareHouse(){
    return  FindDropdown<warehouse.Data>(
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
      onChanged: (warehouse.Data item) {
        itemForm.remove('ID_BODEGA');
        var it = {'ID_BODEGA':item.idBodega};
        itemForm.addAll(it);
      },
      validate: (warehouse.Data item) {
        if (item == null){
           
            Fluttertoast.showToast(
              msg: "No se pudo cargar listado de bodegas",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
            );
             return null;
        }else
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
      onChanged: (EmployeeModel item) => {
        itemForm.remove('ID_EMPLEADO'),
        itemForm.addAll({'ID_EMPLEADO':item.idPersonal}),
        print(itemForm),
        getCCostList(item.idDepartment).then((value) {
          setState(() {
            ccostList = value;
            /* print(itemForm); */
          });
        }),
        getMachineList(item.idDepartment).then((value) {
          setState(() {
            machineList = value;
          });
        }),
        getItemCostList(item.idDepartment).then((value) {
          setState(() {
            itemCostList = value;
          });
        })
      },
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
    return  FindDropdown<CCostoModel>(
      items: ccostList,
      label: "Centro de Costo",
      searchBoxDecoration: InputDecoration(
        labelText: "Centro de Costo",
        prefixIcon: Icon(Icons.info_outline),
        border: OutlineInputBorder()
      ),
      autofocus: true,
      showSearchBox: true,
      labelStyle: TextStyle(
        color: Colors.red
      ),
      searchHint: "Selecciona un centro de costo",
      onChanged: (CCostoModel item) {
        itemForm.remove('ID_CENTRO_COSTO');
        itemForm.addAll({'ID_CENTRO_COSTO':item.cCostoCode});
      },
      //selectedItem: "Busqueda de empleado",
      validate: (CCostoModel item) {
        if (item == null)
          return "Campo Requerido";
        else
          return null; //return null to "no error"
      },
    );
  }

  Widget createDropdownItemCost(){
    return  FindDropdown<ItemCostModel>(
      items: itemCostList,
      label: "Item Gasto",
      searchBoxDecoration: InputDecoration(
        labelText: "Item Gasto",
        prefixIcon: Icon(Icons.info_outline),
        border: OutlineInputBorder()
      ),
      autofocus: true,
      showSearchBox: true,
      labelStyle: TextStyle(
        color: Colors.red
      ),
      searchHint: "Selecciona un Item de Gasto",
      onChanged: (ItemCostModel item) {        
        itemForm.remove('ID_ITEM_GASTO');
        itemForm.addAll({'ID_ITEM_GASTO':item.code});
      },
      //selectedItem: "Busqueda de empleado",
      validate: (ItemCostModel item) {
        if (item == null){
           
            Fluttertoast.showToast(
              msg: "No se pudo cargar listado de bodegas",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
            );
             return null;
        }else
          return null;  //return null to "no error"
      },
    );
  }

  Widget createDropdownMachine(){
    return  FindDropdown<MachineModel>(
      items: machineList,
      label: "Maquina",
      searchBoxDecoration: InputDecoration(
        labelText: "Maquina",
        prefixIcon: Icon(Icons.info_outline),
        border: OutlineInputBorder()
      ),
      autofocus: true,
      showSearchBox: true,
      labelStyle: TextStyle(
        color: Colors.red
      ),
      searchHint: "Selecciona una Maquina",
      onChanged: (MachineModel item) {
        itemForm.remove('ID_MAQUINA');
        itemForm.addAll({'ID_MAQUINA':item.idMachine});
      },
      //selectedItem: "Busqueda de empleado",
      validate: (MachineModel item) {
        if (item == null)
          return "Campo Requerido";
        else
          return null; //return null to "no error"
      },
    );
  }

  _loadComponent(String s) {
    
    switch (s) {
      case 'warehause':
        {
          if (itemsWareHouse != null){
            return (itemsWareHouse.isNotEmpty)?createDropdownWareHouse(): Container()
                /* const Center(child: const CircularProgressIndicator()) */;
          }
        break;
        }
      case 'employee':
      {
        if (employeeList != null){
          return (employeeList.isNotEmpty)?createDropdownEmploye(): Container()
                /* const Center(child: const CircularProgressIndicator() )*/;
        }
        break;
      } 
      case 'machine':{
        if (machineList != null){
           return (machineList.isNotEmpty)? createDropdownMachine(): Container()
                /* const Center(child: const CircularProgressIndicator()) */;
        }
        break;
      }
      case 'ccost':{
        if (ccostList != null){
          return (ccostList.isNotEmpty)?createDropdownCCost(): Container() 
                /* const Center(child: const CircularProgressIndicator()) */;
        }
        break;
      }
      case 'itemcost':{
        if (itemCostList != null){
          return (itemCostList.isNotEmpty)? createDropdownItemCost(): Container()
                /* const Center(child: const CircularProgressIndicator()) */;
        }
        break;
      }

    }
  }

  _validateForm() {

    if (!itemForm.containsKey('ID_BODEGA')){
      return false;
    }
    if (!itemForm.containsKey('ID_EMPLEADO')){
      return false;
    }
    /* if (!itemForm.containsKey('ID_MAQUINA')){
      return false;
    } */
    if (!itemForm.containsKey('ID_ITEM_GASTO')){
      return false;
    }
    if (!itemForm.containsKey('ID_CENTRO_COSTO')){
      return false;
    }

    return true;
  }
}