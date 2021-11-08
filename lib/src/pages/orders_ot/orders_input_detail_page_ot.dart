
import 'dart:convert';

import 'package:eagon_bodega/src/models/ot_model.dart';
import 'package:eagon_bodega/src/models/product_model.dart';
import 'package:eagon_bodega/src/models/response_order_model.dart';
import 'package:eagon_bodega/src/pages/orders_ot/order_form_page_ot.dart';
import 'package:eagon_bodega/src/providers/empty_state_provider.dart';
import 'package:eagon_bodega/src/providers/outgoing_provider.dart';
import 'package:eagon_bodega/src/utils/alert.dart';
import 'package:flutter/material.dart';

class OrderCreatePageOt extends StatefulWidget {
  OrderCreatePageOt({Key key}) : super(key: key);

  @override
  _OrderCreatePageOtState createState() => _OrderCreatePageOtState();
}

class _OrderCreatePageOtState extends State<OrderCreatePageOt> {

  final TextEditingController _searchProduct = new TextEditingController();
  OutgoingProvider outgoingProvider = new OutgoingProvider();
  List<OrderFormOt> detalles = [];
  int _count = 0;
  Map<String, dynamic> saveData = new Map<String, dynamic>();
  bool _enableButtonSave = true;


  @override
  Widget build(BuildContext context) {
    OtModel args = ModalRoute.of(context).settings.arguments;
    //OtModel ot = OtModel.fromJson(jsonDecode(args));
    var head = {'head':{'ID_OT':args.idOt}};
    saveData.addAll(head);

    _loadDetail(args);

    return 
     Scaffold(
      appBar: AppBar(
        elevation: .0,
        title: Text("Ingreso detalle"),//_inputSearchField(),
        actions: <Widget>[
          FlatButton(
            child: Text('Guardar'),
            textColor: Colors.white,
            onPressed: (!_enableButtonSave)?null:(){
              /* setState(() {
                _enableButtonSave = false;
              }); */
              _saveOrder().then((value){
                if (value.success){
                  var baseDialog = BaseAlertDialog(
                  title: "Confirmación",
                  content: value.msg + ' \nNumero Orden:'+ value.lastId.toString(),
                  yesOnPressed: () {
                    Navigator.pushNamed(context, '/orders');
                  },
                  noOnPressed: () {
                    Navigator.pushNamed(context, "/orders");
                  },
                  color: Colors.green.shade100,
                  yes: "OK",
                  no: "Nuevo");

                  showDialog(context: context, builder: (BuildContext context) => baseDialog);
                }else{
                  var baseDialog = BaseAlertDialog(
                  title: "Error",
                  content: value.msg,
                  yesOnPressed: () {
                    Navigator.of(context, rootNavigator: true)
                    .pop();

                    setState(() {
                      _enableButtonSave = false;
                    });
                  },
                  color: Colors.red.shade100,
                  yes: "OK");

                  showDialog(context: context, builder: (BuildContext context) => baseDialog);
                }
              });
            },
          )
        ],
      ),
      body: Container(
        child: 
          Column(
            children: [
              /* Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child:
                  _inputSearchField(),
              ), */
              detalles.length <= 0
                ? Center(
                    child: EmptyState(
                      title: 'Oops',
                      message: 'Debes ingresar al menos un producto',
                    ),
                  )
                : Expanded(
                  child: ListView.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: detalles.length,
                    itemBuilder: (_, i) => detalles[i],
                  ),
                )
            ],
          ),
      ),
    );
  }

  ///on add form
  void onAddForm() {
    getProduct(_searchProduct.text).then((value) {
      setState(() {
        _count++;
        ProductModel _product = value;
        detalles.add(
          OrderFormOt(
            product: _product,
            index: _count,
            onDelete: () => null
          )
        );
      });
    });
  }

  Future<ProductModel> getProduct(productCode){
    return outgoingProvider.getProduct(productCode);
  }

  Future<ResponseOrderModel> _saveOrder() async {
    
    var arr = [];
    detalles.forEach((element) {
      arr.add({
        "CODIGO_PRODUCTO" : element.product.producto,
        "ID_UBICACION" : element.state.ubicacionEditor.text,
        "CANTIDAD" : element.state.cantidadEditor.text,
        "UNIDAD_MEDIDA" : element.state.unidadMedidaEditor.text
      });
    });

    saveData.addAll({'detail':arr});

    ResponseOrderModel response = await outgoingProvider.saveOrder(saveData);
    return response;
  }

  void _loadDetail(OtModel ordersModel) {

      ordersModel.detail.forEach((element) {
        _count++;
        ProductModel _product = new ProductModel(
          element.matDesc,
          null, 
          '',
          null, 
          null, 
          '', 
          element.matDesc, 
          null, 
          null, 
          element.matCod, 
          element.detCant, 
          ''
        );

      detalles.add(
        OrderFormOt(
          product: _product,
          index: _count,
          onDelete: () => null,
        )
      );
    });
  }
}
