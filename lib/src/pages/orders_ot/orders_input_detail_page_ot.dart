
import 'dart:convert';
import 'dart:ffi';

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

    if (detalles.length <= 0){
    _loadDetail(args);
    }

    return 
     Scaffold(
      appBar: AppBar(
        elevation: .0,
        title: Text("Ingreso detalle"),
        backgroundColor: Colors.orange,//_inputSearchField(),
        actions: <Widget>[
          FlatButton(
            child: Text('Guardar'),
            textColor: Colors.white,
            onPressed: (!_enableButtonSave)?null:(){
              var validState = detalles.firstWhere((e) => e.product.idUbicacion == null, orElse: () => null);

              if (validState == null){
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
                    yes: "OK",
                    no: null,);

                    showDialog(context: context, builder: (BuildContext context) => baseDialog);
                  }
                });
              
              }else{
                var baseDialog = BaseAlertDialog(
                    title: "Error",
                    content: "Existen ubicaciones vacias!",
                    yesOnPressed: () {
                      Navigator.of(context, rootNavigator: true)
                      .pop();

                      setState(() {
                        _enableButtonSave = true;
                      });
                    },
                    color: Colors.red.shade100,
                    yes: "OK");

                    showDialog(context: context, builder: (BuildContext context) => baseDialog);
              }
              },
          )
        ],
      ),
      body: Container(
        child: 
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child:
                  _inputSearchField(),
              ),Expanded(
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

  _inputSearchField() {
    return Padding(
        padding: EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
        child: TextFormField(
        //autofocus: true,
        controller: _searchProduct,
        //keyboardType: TextInputType.number,
        //style: TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          labelText: "Escanea una ubicación",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.orange,
            ),
          ),
          focusColor: Colors.grey.shade100,
          fillColor: Colors.grey.shade300,
          hintStyle: TextStyle(
            color: Colors.orange.shade300
          ),
          labelStyle: TextStyle(
            color: Colors.orange.shade900
          ), 
        ),
        validator: (value){
          if(value.isEmpty){
            return 'Valor inválido';
          }
          return null;
        },
        onFieldSubmitted: (String value){
          //TODO: realizar search product y meter en la lista de formularios...
          getProduct(value).then((value) {
            _reprintFormsSearch(value);
          });
          _searchProduct.clear();
        },
      )
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

  Future<ProductModel> _reprintFormsSearch(ProductModel product) {
    if (product.glosa == null){
      var baseDialog = BaseAlertDialog(
        title: "Error",
        content: "No se pudo asignar el producto.",
        yesOnPressed: () {
          Navigator.of(context, rootNavigator: true)
          .pop();
        },
        color: Colors.red.shade100,
        yes: "OK");

        showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }else{
      detalles.forEach((element) {
        var productCode = element.product.producto.replaceAll(' ','');
        var cant = double.parse(product.cantidad);
        if(double.parse(element.product.cantidad) > cant){
          var baseDialog = BaseAlertDialog(
            title: "Error",
            content: "La cantidad del producto no es suficiente, ¿desea generar otra linea de detalle?",
            yesOnPressed: () {
              setState(() {
                
                _count++;
                  ProductModel _product = new ProductModel(
                    element.product.glosa,
                    null, 
                    '',
                    null, 
                    null, 
                    '', 
                    element.product.glosa, 
                    null, 
                    null, 
                    element.product.producto, 
                    element.product.cantidad, 
                    ''
                  );

                detalles.add(
                  OrderFormOt(
                    product: _product,
                    index: _count,
                    onDelete: () => null,
                    backgroundColor:  Colors.green.shade300,
                  )
                );
                
              });
              Navigator.of(context, rootNavigator: true)
              .pop();
            },
            noOnPressed: (){
              Navigator.of(context, rootNavigator: true)
              .pop();
            },
            color: Colors.red.shade100,
            yes: "Sí",
            no: "No",);

            showDialog(context: context, builder: (BuildContext context) => baseDialog);

             if(productCode == product.producto){
              element.state.ubicacionEditor.text = product.idUbicacion;
              element.state.unidadMedidaEditor.text = product.unidadMedida;
              detalles.elementAt(element.index-1).product.idUbicacion = product.idUbicacion;
              detalles.elementAt(element.index-1).product.unidadMedida = product.unidadMedida;
              
            }

        }else{

          if(productCode == product.producto){
            setState(() {  
              element.state.ubicacionEditor.text = product.idUbicacion;
              element.state.unidadMedidaEditor.text = product.unidadMedida;
              detalles.elementAt(element.index-1).product.idUbicacion = product.idUbicacion;
              detalles.elementAt(element.index-1).product.unidadMedida = product.unidadMedida;
            });
          }
        }
      });
    }
  }
}
