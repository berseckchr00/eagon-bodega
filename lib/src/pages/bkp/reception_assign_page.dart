import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/providers/dropdown_provider.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/utils/dropdown_utils.dart';
import 'package:flutter/material.dart';

class ReceptionAssignPage extends StatefulWidget {
  
  @override
  State createState() => _ReceptionAssignPage();
}


class _ReceptionAssignPage extends State<ReceptionAssignPage> {


  DropDownPurchaseOrderProvider _dropDownPurchaseOrderProvider2 = new
  DropDownPurchaseOrderProvider();

  DropDownPurchaseOrderProvider _dropDownPurchaseOrderProvider3 = new
  DropDownPurchaseOrderProvider();

  

  final _formKey = GlobalKey<FormState>();

  final _folio =  '65778';
  final _rut = '96817490-8';
  
  
  List<Widget> _detail;
  List<Widget> _dropDownList = [];

  String _ocNumber;
  String _ocRef;

  @override
  Widget build(BuildContext context) {
    final title = 'Recepción Orden de Compra';
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Custom Dropdown'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: (_detail != null)?_detail:[],
              ),
            )/* ,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children:(_dropDownList != null)?_dropDownList:[],
              )
            ), */
          ],
        ),
        
      ),
    );

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

    _searchPendantReceptions(this._rut, this._folio).then((value) => 
      {
        if(value.data.head.ref != null){
          _ocRef = value.data.head.ref,
          _searchPurchaseOrder(_ocRef).then((ocData) => {
          
            /*ocData.data.details.forEach((element) {
              lstProv.add(new PurchaseOrderClass(
                  productCode: element.codigoProducto,
                  productGlosa: element.glosa
                ));
              /*_dropDownPurchaseOrderProvider.getPurchaseModelList().add(
                new PurchaseOrderClass(
                  productCode: element.codigoProducto,
                  productGlosa: element.glosa
                )
              );*/
            }),*/

            setState(() {
              _ocNumber = ocData.data.head.numero;
              //_header = _generate_datos_oc(ocData);
              
              _detail = _generateDetailOc(ocData.data.details);

              ocData.data.details.forEach((element) {
                DropDownPurchaseOrderProvider provider = setDropDownPurchaseOrderProvider();

                ocData.data.details.forEach((element) {
                  
                  provider.getPurchaseModelList().add(
                    new PurchaseOrderClass(
                      productCode: element.codigoProducto,
                      productGlosa: element.glosa
                    )
                  );
                });

                provider.setPurchaseModelDropdownList(
                  provider.buildPurchaseModelDropdown(
                    provider.getPurchaseModelList()
                  )
                );  
                
                provider.setPurchaseModel(provider.getPurchaseModelList()[0]);

                
                _dropDownList.add( _generateDropDown('1', provider));
              });
              
              //_dropDown = _generateDropDown();
            })
          })
        }else{
          setState(() {
            //_header = _generate_datos_oc(null);
            _detail = [];
            _dropDownList = [];
          })
        }
        
      }
    );
    
    super.initState();
  }

  _onChangePurchaseModelDropdown2(PurchaseOrderClass favouriteFoodModel) {
    setState(() {
      _dropDownPurchaseOrderProvider2.setPurchaseModel(favouriteFoodModel);
    });
  }
  _onChangePurchaseModelDropdown3(PurchaseOrderClass favouriteFoodModel) {
    setState(() {
      _dropDownPurchaseOrderProvider3.setPurchaseModel(favouriteFoodModel);
    });
  }

  


  Widget _createDetailCardOc(
    Detail orderItem, 
    String key, 
    DropDownPurchaseOrderProvider _dropDownPurchaseOrderProvider){
    
    return /*Container(
      color: Colors.grey.shade300,
      //padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [*/
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
                  ),
                 
                ),

                Text(orderItem.unidadIngreso,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                    )
                ),
              ]      
            ),
            trailing: 
              IconButton(
                icon: const Icon(Icons.find_in_page_rounded),
                tooltip: 'Asignar detalle',
                onPressed: () { 
                  //_showOrderDialog(context, key, _dropDownPurchaseOrderProvider);
                },
              ),
            );    
        /*],
      ),
    );*/
  }


  Future<void> _showOrderDialog(
    BuildContext context, 
    String key, 
    DropDownPurchaseOrderProvider _dropDownPurchaseOrderProvider) async{

    return await showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(builder: (conext, setState){
          return AlertDialog(
            content: Form(
              key: _formKey,
              child:  _generateDropDown(key, _dropDownPurchaseOrderProvider),
            ),
          );
        });
      });
  }

  List<Widget> _generateDetailOc(List<Detail> listOrder){
    
    List<Widget> _det = [];
    int index = 1;

    listOrder.forEach((element) {
      DropDownPurchaseOrderProvider provider = setDropDownPurchaseOrderProvider();

      listOrder.forEach((element) {
        
        provider.getPurchaseModelList().add(
          new PurchaseOrderClass(
            productCode: element.codigoProducto,
            productGlosa: element.glosa
          )
        );
      });

      provider.setPurchaseModelDropdownList(
        provider.buildPurchaseModelDropdown(
          provider.getPurchaseModelList()
        )
      );  

      provider.setPurchaseModel(provider.getPurchaseModelList()[0]);
      _det.add(_createDetailCardOc(element, index.toString(), provider));
      _det.add( _generateDropDown(index.toString(), provider));
      index ++;
    }); 

    return _det;
  }

  Widget _generateDropDown(
    String key,
    DropDownPurchaseOrderProvider _dropDownPurchaseOrderProvider){

    return new DropdownUtils(
        key: Key(key),
        dropdownMenuItemList: _dropDownPurchaseOrderProvider.getPurchaseModelDropdownList(),
        onChanged: (value){
          this.setState(() {
            _dropDownPurchaseOrderProvider.setPurchaseModel(value);
          });
        },
        value: _dropDownPurchaseOrderProvider.getPurchaseModel(),
        isEnabled: true,
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

  DropDownPurchaseOrderProvider setDropDownPurchaseOrderProvider(){

    DropDownPurchaseOrderProvider _dropDownPurchaseOrderProvider = new
    DropDownPurchaseOrderProvider();

           
    return _dropDownPurchaseOrderProvider;
  }  

}