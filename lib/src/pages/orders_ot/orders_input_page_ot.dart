
import 'package:eagon_bodega/src/forms/orders_input_form.dart';
import 'package:eagon_bodega/src/models/order_model.dart';
import 'package:eagon_bodega/src/providers/outgoing_provider.dart';
import 'package:eagon_bodega/src/providers/warehause_provider.dart';
import 'package:flutter/material.dart';

class OrdersInputOt extends StatefulWidget {
  OrdersInputOt({Key key}) : super(key: key);

  @override
  _OrdersInputOtState createState() => _OrdersInputOtState();
}

class _OrdersInputOtState extends State<OrdersInputOt> {

  OrderInputForm orderInputField = new OrderInputForm();
  WareHouseProvider wareHouseProvider = new WareHouseProvider();
  OutgoingProvider outgoingProvider = new OutgoingProvider(); 
  OrdersModel responseOt = new OrdersModel();
  final TextEditingController _ctrlWarehouse = new TextEditingController();
  final TextEditingController _ctrlEmployee = new TextEditingController();
  final TextEditingController _ctrlMachine = new TextEditingController();
  final TextEditingController _ctrlCcost = new TextEditingController();
  final TextEditingController _ctrlItemCost = new TextEditingController();

  Map<String, dynamic> itemForm = new Map<String, dynamic>();
  var args;

  Map keyboardTypes = {
    "number": TextInputType.number,
  };
  dynamic response;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      
      args = ModalRoute.of(context).settings.arguments;
      getOtData(args).then((value) => {
        setState(() {
          responseOt = value;
          _ctrlWarehouse.text = responseOt.bodega;
          _ctrlEmployee.text = responseOt.nombreSolicitante;
          _ctrlMachine.text = responseOt.maquina;
          _ctrlCcost.text = responseOt.centroCosto;
          _ctrlItemCost.text = responseOt.itemGasto;
        })
      });
    });
    
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    return (responseOt == null)? const Center(child: const CircularProgressIndicator()): new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("Generación de Pedido"),
      ),
      body: 
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
              child: _createTextFormField((responseOt != null)?responseOt.bodega:'', "Bodega", _ctrlWarehouse)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField((responseOt != null)?responseOt.nombreSolicitante:'', "Empleado", _ctrlEmployee)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField((responseOt != null)?responseOt.maquina:'', "Maquina", _ctrlMachine)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField((responseOt != null)?responseOt.centroCosto:'', "Centro Costo", _ctrlCcost)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField((responseOt != null)?responseOt.itemGasto:'', "Item de Gasto", _ctrlItemCost)
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

  Future<OrdersModel> getOtData(String otNumber) async {    
    OrdersModel response = await outgoingProvider.getOtData(otNumber);
    print(otNumber);
    return response;
  }

  Widget _createTextFormField(String text, String label, TextEditingController controller) {
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
    //initialValue: text,
    controller: controller,
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