/// Flutter code sample for ReorderableListView

import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
/// This is the main application widget.
class ReceptionOrderList extends StatelessWidget {
  
  static const String _title = 'Asignación Detalles';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body:  MyStatefulWidget(),
      );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<int> _items = [];
  List<Item> _itemsDetail = [];
  //List<int> _itemsOrder = []; 
  List<int> _itemsOrder = List<int>.generate(2, (int index) => index);
  List<Detail> _itemsOrderDetail = [];
  String _ocRef;

  final _folio =  '65778';
  final _rut = '96817490-8';

  @override
  void initState() {
    
    _searchPendantReceptions(this._rut, this._folio).then((value) => 
    {
      _ocRef = value.data.head.ref,
      _searchPurchaseOrder(_ocRef).then((ocData) => {
        
        setState(() {
          _itemsDetail = value.data.items;
          _items = List<int>.generate(_itemsDetail.length, (int index) => index);
          
          _itemsOrderDetail = ocData.data.details;
          _itemsOrder = List<int>.generate(_itemsOrderDetail.length, (int index) => index);

          
        })
      })
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return (_items.length > 0)?
      Column(
        children: [
          Row(
            children: [
              
              Expanded(
                child: 
                  ListTile(
                    title: Text(
                      "Detalle Recepción",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
              ), Expanded(
                child: 
                  ListTile(
                    title: Text(
                      "Detalle Order Compra",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
              ),
            ],
          ),
          Expanded(
            child:
              _createList() 
              //Text("Detalle Guía")
          ),          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange
                ),
                onPressed: (){
                  Fluttertoast.showToast(
                    msg: "Not Implemented yet!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    fontSize: 16.0
                  );
                }, 
                child: Text("Seguiente"),
                    
                )
            ],
          )
        ],
      ):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[CircularProgressIndicator()]
          )
        ]
      );
  }

  Widget _createList(){

    Color oddItemColorDetail = Colors.orange[800].withOpacity(0.05);//colorScheme.primary.withOpacity(0.05);
    final Color oddItemColor = Colors.orange[800].withOpacity(0.05);//colorScheme.primary.withOpacity(0.05);
    Color evenItemColorDetail = Colors.orange[400].withOpacity(0.15);
    final Color evenItemColor = Colors.orange[400].withOpacity(0.15);


    return Row(
      children: [
        Expanded(
          child: 
          ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            children: <Widget>[
              for (int index = 0; index < _items.length; index++)
                //_generateItemList(_itemsDetail[index], index)
                ListTile(
                  minVerticalPadding: 10,
                  key: Key('$index'),
                  tileColor: _items[index].isOdd ? oddItemColorDetail : evenItemColorDetail,
                  title: Text('${_itemsDetail[index].nmbItem}'),
                  subtitle: Row(
                    children: [
                      Text(
                        'Cant.: ',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      Expanded(
                        child: 
                        TextFormField(
                          initialValue: double.parse(_itemsDetail[index].qtyItem).toString(),
                          style: TextStyle(fontSize: 14.0),
                          readOnly: true,
                          textAlign: TextAlign.center,
                          validator: (value){
                            if(value.isEmpty || double.parse(value) < 1){
                              return 'Cantidad Invalida';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            print(value);
                          },
                        ),
                      ),
                      Text(
                        ' ${_itemsDetail[index].unmdItem}',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.chevron_right_sharp
                  ),
                ),
            ],
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final int item = _items.removeAt(oldIndex);
                final Item det = _itemsDetail.removeAt(oldIndex);
                _items.insert(newIndex, item);
                _itemsDetail.insert(newIndex, det);
              });
            },
          ),
        ),
        Expanded(
          child:
          ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            children: <Widget>[
              for (int index = 0; index < _itemsOrder.length; index++)
                //_generateOrderDetailList(_itemsOrderDetail[index], index)
                 ListTile(
                  minVerticalPadding: 10,
                  key: Key('$index'),
                  tileColor: _itemsOrder[index].isOdd ? oddItemColor : evenItemColor,
                  title: Text('${_itemsOrderDetail[index].glosa}'),
                  subtitle: Row(
                    children: [
                      Text(
                        'Cant.: ',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      Expanded(
                        child: 
                        TextFormField(
                          initialValue: double.parse(_itemsOrderDetail[index].cantidad).toString(),
                          style: TextStyle(fontSize: 16.0),
                          readOnly: true,
                          textAlign: TextAlign.center,
                          validator: (value){
                            if(value.isEmpty || double.parse(value) < 1){
                              return 'Cantidad Invalida';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            print(value);
                          },
                        ),
                      ),
                      Text(
                        ' ${_itemsOrderDetail[index].unidadIngreso}',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                    ],
                  )
                  /*leading: Icon(
                    Icons.chevron_left_sharp
                  ),*/
                )
            ],
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final int item = _itemsOrder.removeAt(oldIndex);
                final Detail det = _itemsOrderDetail.removeAt(oldIndex);

                _itemsOrder.insert(newIndex, item);
                _itemsOrderDetail.insert(newIndex, det);

                oddItemColorDetail = Colors.green[800].withOpacity(0.05);
                evenItemColorDetail = Colors.green[400].withOpacity(0.15);
              });
            },
          )
        ),
      ],
    ); 
  }
  Future<DteModel> _searchPendantReceptions(String rut, String folio) async{
    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteDetail(rut, folio);      
    return _dte;
  }

  Future<PurchaseOrderModel> _searchPurchaseOrder(String num_oc) async{
    ReceptionProvider reception = new ReceptionProvider();
    PurchaseOrderModel _porder = await reception.getOc(num_oc);

    return _porder;
  }

  Widget _generateItemList(Item dteItem, int index){
    int lineNumber = index++;

    return Container(
      key: Key('$index'),
      color: Colors.grey.shade300,
      //padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          ListTile(
            leading: Text(
              lineNumber.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            title: Text(dteItem.nmbItem),
            subtitle: Row(
              children:[
                Expanded(
                child: 
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                       hintStyle: TextStyle(
                         color: Colors.orange.shade300
                       ),
                       labelStyle: TextStyle(
                         color: Colors.orange.shade900
                       ), 
                    ),
                    readOnly: false,
                    initialValue: dteItem.qtyItem,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                 
                ),

                Text(dteItem.unmdItem,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                    )
                ),
              ]      
            ),
            )
          ]
         )
      );  
  }

  Widget _generateOrderDetailList(Detail dteItem, int index){
    int lineNumber = index++;

    return Container(
      key: Key('$index'),
      color: Colors.grey.shade300,
      //padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          ListTile(
            leading: Text(
              lineNumber.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            title: Text(dteItem.glosa),
            subtitle: Row(
              children:[
                Expanded(
                child: 
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                       hintStyle: TextStyle(
                         color: Colors.orange.shade300
                       ),
                       labelStyle: TextStyle(
                         color: Colors.orange.shade900
                       ), 
                    ),
                    readOnly: false,
                    initialValue: dteItem.cantidad,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                 
                ),

                Text(dteItem.unidadIngreso,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                    )
                ),
              ]      
            ),
            )
          ]
         )
      );  
  }
}
