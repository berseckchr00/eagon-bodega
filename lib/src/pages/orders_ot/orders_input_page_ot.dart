
import 'package:eagon_bodega/src/forms/orders_input_form.dart';
import 'package:eagon_bodega/src/models/ot_model.dart';
import 'package:eagon_bodega/src/providers/outgoing_provider.dart';
import 'package:eagon_bodega/src/providers/warehause_provider.dart';
import 'package:eagon_bodega/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersInputOt extends StatefulWidget {
  OrdersInputOt({Key key}) : super(key: key);

  @override
  _OrdersInputOtState createState() => _OrdersInputOtState();
}

class _OrdersInputOtState extends State<OrdersInputOt> {

  OrderInputForm orderInputField = new OrderInputForm();
  WareHouseProvider wareHouseProvider = new WareHouseProvider();
  OutgoingProvider outgoingProvider = new OutgoingProvider(); 
  OtModel responseOt = new OtModel();
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
          if (value == null){
            _showMessage();
          }else{
            if (responseOt.detail.isNotEmpty){
              _ctrlWarehouse.text = responseOt.idOt;            
              final f = new DateFormat('dd-MM-yyyy');
              var fchEmis = f.format(DateTime.parse(responseOt.fechaOt));
              
              _ctrlEmployee.text = fchEmis;
              _ctrlMachine.text = responseOt.descripcionActivo;
              _ctrlCcost.text = responseOt.descripciponTarea;
              _ctrlItemCost.text = responseOt.solicitadoPor;
            }
          }
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
              child: _createTextFormField((responseOt.idOt != null)?responseOt.idOt:'', "Número OT", _ctrlWarehouse)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField((responseOt.fechaOt  != null)?responseOt.fechaOt:'', "Fecha", _ctrlEmployee)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField((responseOt.descripcionActivo  != null)?responseOt.descripcionActivo:'', "Descripción Activo", _ctrlMachine)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField((responseOt.descripciponTarea  != null)?responseOt.descripciponTarea:'', "Descripción Tarea", _ctrlCcost)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _createTextFormField((responseOt.solicitadoPor != null)?responseOt.solicitadoPor:'', "Solcitado por", _ctrlItemCost)
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

  Future<OtModel> getOtData(String otNumber) async {    
    OtModel response = await outgoingProvider.getOtData(otNumber);
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

  void _showMessage() {
     var baseDialog = BaseAlertDialog(
        title: "Confirmación",
        content: "No se pudo encontrar OT",
        yesOnPressed: () {
          Navigator.pushNamed(context, '/orders');
        },
        noOnPressed: () {
          Navigator.pushNamed(context, "/orders");
        },
        color: Colors.green.shade100,
        yes: "OK",
        no: "Cancelar");

        showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

}