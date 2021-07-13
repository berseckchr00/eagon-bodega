import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:eagon_bodega/src/utils/form_utils.dart' as form_utils;
import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:flutter/material.dart';

class ReceptionAssignPage extends StatefulWidget {
  
  @override
  State createState() => _ReceptionAssignPage();
}

class DataTest {
  const DataTest(this.name);    
  final String name;
}

class _ReceptionAssignPage extends State<ReceptionAssignPage> {

  final _folio =  '65778';
  final _rut = '96817490-8';

  List<Widget> _detail;
  DataTest _selectedOrder;
  DataTest selectedUser;
  List<DataTest> dataTestObj = <DataTest>[DataTest('REGULADOR 114799 0-6\"'), DataTest('SOPORTE REDONDO FC-206  30')];
  Widget dropDown;
  String _ocNumber;

  @override
  Widget build(BuildContext context) {
    final title = 'Recepción Orden de Compra';

    /*return MaterialApp(
      title: title,
      home: Scaffold(
        body : Container(
          margin: EdgeInsets.only(top: 500),
          child:_generateDropDown(dataTestObj))
      )
    );*/

    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Container(
                margin: EdgeInsets.only(top: 15.0),
                child:
                  Column(
                    children: [
                      Padding(padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(title),
                          Text(_ocNumber==null?'':_ocNumber)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              floating: true,
              //flexibleSpace: Text("Flex"),
              expandedHeight: 100,
            ),
            SliverList(
              
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(

                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                (context, index) => _detail[index],
                // Builds 1000 ListTiles
                childCount: (_detail == null)?0:_detail.length,
              ),
            ),
          ],
        ),
      );
  }

  @override
  void initState() { 
    super.initState();

    _searchPendantReceptions(this._rut, this._folio).then((value) => 
      {
        if(value.data.head.ref != null){
          _searchPurchaseOrder(value.data.head.ref).then((ocData) => {
          
            setState(() {
              _ocNumber = ocData.data.head.numero;
              //_header = _generate_datos_oc(ocData);
              _detail = _generate_detail_oc(ocData.data.details);
              //dropDown = _generateDropDown(ocData.data.details);
            })
          })
        }else{
          setState(() {
            //_header = _generate_datos_oc(null);
            _detail = [];
          })
        }
        
      }
    );
  }

  List<Widget> _generate_detail(PurchaseOrderModel orderModel, List<Item> detailItems) {
    List<Widget> _det = [];
    List<Detail> _detOrder = (orderModel != null)?orderModel.data.details:[];

    detailItems.forEach((element) {
      _det.add(_createDetailCard(element, _detOrder));
    });
    
    return _det;
  }

  Widget _createDetailCard(Item it, List<Detail> lstDetailOc){
    
    return Container(
      color: Colors.grey.shade300,
      //padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            leading: Text(
              it.nroLinDet,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            title: Text(it.nmbItem),
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
                    initialValue: it.qtyItem,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  )
                ),
                Text(it.unmdItem,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                    )
                ),
              ]      
            )        
          )
        ],
      ),
    );
  }

  Widget _createDetailCardOc(Detail orderItem){
    
    return Container(
      color: Colors.grey.shade300,
      //padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            leading: Text(
              orderItem.linea,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            title: Text(orderItem.glosa),
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
                    initialValue: orderItem.cantidad,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  )
                ),
                Text(orderItem.unidadIngreso,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                    )
                ),
              ]      
            )        
          )
        ],
      ),
    );
  }


  List<Widget> _generate_detail_oc(List<Detail> listOrder){
    List<Widget> _det = [];
    listOrder.forEach((element) {
      _det.add(_createDetailCardOc(element));
      _det.add(_generateDropDown(dataTestObj));
    });

    return _det;
  }

  Widget _generateDropDown(List<DataTest>lstDetailOc){
    return new DropdownButton<DataTest>(
            hint: new Text(
                (lstDetailOc.isNotEmpty)?"Seleccione un producto":"Sin Orden de Compra", 
                style:  new TextStyle(color: Colors.black)),
            value: _selectedOrder,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 24,
            onChanged: (DataTest newValue){
              _selectedOrder = newValue ;
              this.setState(() {
                print(newValue.name);
              });
            },
            //items: _getDropDownMenuItemOrder(lstDetailOc)
            items: lstDetailOc.map((DataTest order) {
              return new DropdownMenuItem<DataTest>(
                value: order,
                child: new Text(
                  //order.codigoProducto + ' '+order.glosa,
                  order.name,
                  style:  new TextStyle(color: Colors.black, fontSize: 14)
                )
              );
            }).toList()
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

  

}