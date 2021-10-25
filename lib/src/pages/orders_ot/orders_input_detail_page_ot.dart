
import 'dart:convert';

import 'package:eagon_bodega/src/models/order_model.dart';
import 'package:eagon_bodega/src/models/product_model.dart';
import 'package:eagon_bodega/src/models/response_order_model.dart';
import 'package:eagon_bodega/src/pages/orders/order_form_page.dart';
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
  List<OrderForm> detalles = [];
  int _count = 0;
  Map<String, dynamic> saveData = new Map<String, dynamic>();
  bool _enableButtonSave = true;


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    
    saveData.addAll({'data':args});

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
              setState(() {
                _enableButtonSave = false;
              });
              _saveOrder().then((value){
                if (value.success){
                  var baseDialog = BaseAlertDialog(
                  title: "Confirmación",
                  content: value.msg + ' \nNumero Orden:'+ value.lastId.toString(),
                  yesOnPressed: () {
                    Navigator.pushNamed(context, '/orders');
                  },
                  noOnPressed: () {
                    Navigator.pushNamed(context, "/orders_input");
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

  ///on form user deleted
  void onDelete(ProductModel _detail) {
    setState(() {
      var find = detalles.firstWhere(
        (it) => it.product == _detail,
        orElse: () => null,
      );
      if (find != null) detalles.removeAt(detalles.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    getProduct(_searchProduct.text).then((value) {
      setState(() {
        _count++;
        ProductModel _product = value;
        detalles.add(
          OrderForm(
            product: _product,
            index: _count,
            onDelete: () => onDelete(_product),
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
        "ID_UBICACION" : element.product.idUbicacion,
        "CANTIDAD" : element.state.cantidadEditor.text,
        "UNIDAD_MEDIDA" : element.state.unidadMedidaEditor.text
      });
    });

    saveData.addAll({'detail':arr});
    ResponseOrderModel response = await outgoingProvider.saveOrder(saveData);
    return response;
  }

  void _loadDetail(OrdersModel ordersModel) {

    
    ordersModel.detalle.forEach((element) {
      _count++;
      ProductModel _product = new ProductModel(
        element.nombreProducto, 
        null, 
        element.ubicacion,
        null, 
        null, 
        element.ubicacion, 
        ordersModel.bodega, 
        null, 
        null, 
        element.codigoProducto, 
        element.cantidad, 
        element.unidadMedida
      );
      detalles.add(
        OrderForm(
          product: _product,
          index: _count,
          onDelete: () => onDelete(_product),
        )
      );
    });
  }
}
