import 'dart:convert';

import 'package:eagon_bodega/src/models/order_model.dart';
import 'package:eagon_bodega/src/models/product_model.dart';
import 'package:eagon_bodega/src/pages/order_form_page.dart';
import 'package:eagon_bodega/src/providers/empty_state_provider.dart';
import 'package:eagon_bodega/src/providers/outgoing_provider.dart';
import 'package:flutter/material.dart';

class OrderCreatePage extends StatefulWidget {
  OrderCreatePage({Key key}) : super(key: key);

  @override
  _OrderCreatePageState createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends State<OrderCreatePage> {

  final TextEditingController _searchProduct = new TextEditingController();
  OutgoingProvider outgoingProvider = new OutgoingProvider();
  List<OrderForm> detalles = [];
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        title: Text("Ingreso detalle"),//_inputSearchField(),
        actions: <Widget>[
          FlatButton(
            child: Text('Guardar'),
            textColor: Colors.white,
            onPressed: (){

            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF30C1FF),
              Color(0xFF2AA7DC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: 
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child:
                  _inputSearchField(),
              ),
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
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddForm,
        foregroundColor: Colors.white,
      ), */
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
    print(_searchProduct.text);
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
    /* setState(() {
      _count++;
      Detalle _detalle = Detalle.fromJson(jsonDecode("{\"codigo_producto\":\"LM001\",\"nombre_producto\":\"List\u00f3n mediano 2' 5\/4\",\"cantidad\":\"10\",\"unidad_medida\":\"UN\"}"));
      detalles.add(OrderForm(
        product: _detalle,
        index: _count,
        onDelete: () => onDelete(_detalle),
      ));
    }); */
  }

  _inputSearchField() {
    return Padding(
        padding: EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
        
        child: TextFormField(
        controller: _searchProduct,
        keyboardType: TextInputType.number,
        //style: TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          labelText: "Ingresa un producto",
          border: OutlineInputBorder(),
          focusColor: Colors.grey.shade100,
          fillColor: Colors.grey.shade300

        ),
        validator: (value){
          if(value.isEmpty){
            return 'Valor inválido';
          }
          return null;
        },
        onFieldSubmitted: (String value){
          setState(() {
            (value.length > 0)? onAddForm(): print("invalid value");
          });
          _searchProduct.clear();
        },
      )
    );
  }

  Future<ProductModel> getProduct(productCode){
    return outgoingProvider.getProduct(productCode);
  }
}
