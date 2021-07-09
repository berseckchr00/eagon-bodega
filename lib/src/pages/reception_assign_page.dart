import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:eagon_bodega/src/utils/form_utils.dart' as form_utils;
import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:flutter/material.dart';

class ReceptionAssignPage extends StatefulWidget {
  
  @override
  State createState() => _ReceptionAssignPage();
}

class User {
  const User(this.name);    
  final String name;
}

class _ReceptionAssignPage extends State<ReceptionAssignPage> {

  final _folio =  '65778';
  final _rut = '96817490-8';

  Widget _header = Container();
  List<Widget> _detail;
  Detail _selectedOrder;
  User selectedUser;
  List<User> users = <User>[User('REGULADOR 114799 0-6\"'), User('SOPORTE REDONDO FC-206  30')];
  Widget dropDown;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Asignación - Recepción')
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
              _header,
              Divider(),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text('Detalle Documento'),
              ),
              Divider(),
              Column(children: (_detail!= null)?_detail:[Text('Cargando...')]),
              //(dropDown!= null)?dropDown:Text('Generando detalle OC...')
              new DropdownButton<User>(
                  //hint: new Text("Seleccione un item"),
                  value: selectedUser,
                  onChanged: (User newValue) {
                    setState(() {
                      selectedUser = newValue;
                    });
                  },
                  items: users.map((User user) {
                    return new DropdownMenuItem<User>(
                      value: user,
                      child: new Text(
                        user.name,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ), 
                
              ],
            )
          )
        )
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
              _header = generate_datos_oc(ocData);
              _detail = _generate_detail(ocData, value.data.items);
              dropDown = generateDropDown(ocData.data.details);
            })
          })
        }else{
          setState(() {
            _header = generate_datos_oc(null);
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
          /*new DropdownButton<Detail>(
            hint: new Text(
                (lstDetailOc.isNotEmpty)?"Seleccione un producto":"Sin Orden de Compra", 
                style:  new TextStyle(color: Colors.black)),
            value: _selectedOrder,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 24,
            onChanged: (Detail newValue){
              _selectedOrder = newValue ;
              setState(() {});
            },
            //items: _getDropDownMenuItemOrder(lstDetailOc)
            items: lstDetailOc.map((Detail order) {
              return new DropdownMenuItem<Detail>(
                value: order,
                child: new Text(
                  order.codigoProducto + ' '+order.glosa,
                  style:  new TextStyle(color: Colors.black, fontSize: 14)
                )
              );
            }).toList()
          )*/
        ],
      ),
    );
  }

  Widget generateDropDown(List<Detail> lstDetailOc){
    return new DropdownButton<Detail>(
            hint: new Text(
                (lstDetailOc.isNotEmpty)?"Seleccione un producto":"Sin Orden de Compra", 
                style:  new TextStyle(color: Colors.black)),
            value: _selectedOrder,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 24,
            onChanged: (Detail newValue){
              _selectedOrder = newValue ;
              setState(() {});
            },
            //items: _getDropDownMenuItemOrder(lstDetailOc)
            items: lstDetailOc.map((Detail order) {
              return new DropdownMenuItem<Detail>(
                value: order,
                child: new Text(
                  order.codigoProducto + ' '+order.glosa,
                  style:  new TextStyle(color: Colors.black, fontSize: 14)
                )
              );
            }).toList()
          );
  }
  Widget generate_datos_oc(PurchaseOrderModel orderModel){

    return Column(
      children: <Widget>[
        (orderModel == null)?Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: (){
              //_showDeliveryDialog(context);
            },
            child: Icon(Icons.search)
          ),
        ],
        ):Row(),
        form_utils.createTextFormField('Numero',(orderModel != null)?orderModel.data.head.numero:'', true),
        form_utils.createTextFormField('Fecha',(orderModel != null)?orderModel.data.head.fecha.toString():'', true),
        form_utils.createTextFormField('Porcentaje Asignado',(orderModel != null)?orderModel.data.head.porcentajeAsignado:'', true),
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

}