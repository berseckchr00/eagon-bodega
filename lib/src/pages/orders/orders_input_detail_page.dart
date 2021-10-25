
import 'package:eagon_bodega/src/models/product_model.dart';
import 'package:eagon_bodega/src/models/response_order_model.dart';
import 'package:eagon_bodega/src/pages/orders/order_form_page.dart';
import 'package:eagon_bodega/src/providers/empty_state_provider.dart';
import 'package:eagon_bodega/src/providers/outgoing_provider.dart';
import 'package:eagon_bodega/src/utils/alert.dart';
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
  Map<String, dynamic> saveData = new Map<String, dynamic>();
  bool _enableButtonSave = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    
    saveData.addAll({'head':args});

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
                //_enableButtonSave = false;
                _enableButtonSave = true;
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
        if(value.glosa != null){
          _count++;
          ProductModel _product = value;
          detalles.add(
            OrderForm(
              product: _product,
              index: _count,
              onDelete: () => onDelete(_product),
            )
          );
        }else{
          var baseDialog = BaseAlertDialog(
                  title: "Error",
                  content: "Error al leer Ubicación",
                  noOnPressed:(){
                    Navigator.of(context, rootNavigator: true)
                    .pop();

                    setState(() {
                      _enableButtonSave = false;
                    });
                  },
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
    });
  }

  _inputSearchField() {
    return Padding(
        padding: EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
        
        child: TextFormField(
        autofocus: true,
        controller: _searchProduct,
        //keyboardType: TextInputType.number,
        //style: TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          labelText: "Escanea una ubicación",
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
}
