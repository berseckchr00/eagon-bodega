/// Flutter code sample for ReorderableListView

import 'dart:convert';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/models/reception_response.dart';
import 'package:eagon_bodega/src/pages/receptions/reception_dte.dart';
import 'package:eagon_bodega/src/pages/receptions/resume/reception_resumen.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ReceptionArguments {
  final String detailPurchase;
  final String detailReception;

  ReceptionArguments(this.detailPurchase, this.detailReception);
}

/// This is the main application widget.
class ReceptionOrderList extends StatefulWidget {
  ReceptionOrderList({Key key}) : super(key: key);

  @override
  _ReceptionOrderState createState() {
    return _ReceptionOrderState();
  }
}

// This is the private State class that goes with MyStatefulWidget.
class _ReceptionOrderState extends State<ReceptionOrderList> {
  List<int> _items = [];
  List<Item> _itemsDetail = [];
  //List<int> _itemsOrder = [];
  List<int> _itemsOrder = List<int>.generate(0, (int index) => index);
  List<Detail> _itemsOrderDetail = [];
  String _ocRef;
  DteModel _dteData;
  PurchaseOrderModel _ocData;

  @override
  Widget build(BuildContext context) {
    String _title = 'Asignación Detalles';
    final dteargs = ModalRoute.of(context).settings.arguments as fullArguments;

    _dteData = dteargs.dteModel;
    _ocData = dteargs.ocModel;
    _poolListDte(dteargs.dteModel, dteargs.ocModel);

    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.orange,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              onPressed: () {
                _checkList();
              },
              child: Text("Guardar"),
            ),
          ],
        ),
        body: (_itemsDetail.length > 0)
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                        title: Text(
                          "Detalle Recepción",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                      Expanded(
                          child: ListTile(
                        title: Text(
                          "Detalle Order Compra",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                  Expanded(child: _createList()),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()])
                  ]));
  }

  void _poolListDte(DteModel _dte, PurchaseOrderModel _porder) {
    _itemsDetail = _dte.data.items;
    _items = List<int>.generate(_itemsDetail.length, (int index) => index);

    if (_porder != null) {
      _itemsOrderDetail = _porder.data.details;
      _itemsOrder =
          List<int>.generate(_itemsOrderDetail.length, (int index) => index);
    }
  }

  Widget _createList() {
    Color oddItemColorDetail = Colors.orange[800]
        .withOpacity(0.05); //colorScheme.primary.withOpacity(0.05);
    final Color oddItemColor = Colors.orange[800]
        .withOpacity(0.05); //colorScheme.primary.withOpacity(0.05);
    Color evenItemColorDetail = Colors.orange[400].withOpacity(0.15);
    final Color evenItemColor = Colors.orange[400].withOpacity(0.15);

    return Row(
      children: [
        Expanded(
          child: ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            children: <Widget>[
              for (int index = 0; index < _itemsDetail.length; index++)
                //_generateItemList(_itemsDetail[index], index)
                Column(
                  key: Key('$index'),
                  children: [
                    ListTile(
                        key: ObjectKey(_itemsDetail[index]),
                        minVerticalPadding: 5,
                        tileColor: _items[index].isOdd
                            ? oddItemColorDetail
                            : evenItemColorDetail,
                        title: Text(
                          "${_itemsDetail[index].nmbItem} / ${_itemsDetail[index].dscItem}\n\n Precio : ${"\$ " + _itemsDetail[index].prcItem}",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Container(
                            child: Row(children: [
                          Text('Cant. ${_itemsDetail[index].unmdItem}: ',
                              style: TextStyle(fontSize: 14)),
                          Expanded(
                              child: TextFormField(
                                  // decoration: InputDecoration(
                                  //     labelText:
                                  //         _itemsDetail[index].unmdItem),
                                  keyboardType: TextInputType.number,
                                  initialValue:
                                      _itemsDetail[index].qtyItem.toString(),
                                  style: TextStyle(fontSize: 14.0),
                                  //readOnly: true,
                                  textAlign: TextAlign.start,
                                  onChanged: (String value) {
                                    setState(() {
                                      _itemsDetail[index].qtyItem = value;
                                    });
                                  }))
                        ]))),
                    Divider(
                      color: Colors.grey.shade900,
                    )
                  ],
                )
            ],
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _itemsDetail.removeAt(oldIndex);
                //final i = _items.removeAt(oldIndex);
                _itemsDetail.insert(newIndex, item);
                //_items.insert(newIndex, i);
              });
            },
          ),
        ),
        Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                itemCount: _itemsOrderDetail.length,
                itemBuilder: (context, index) {
                  final item = _itemsOrderDetail[index];
                  final itemName = _itemsOrderDetail[index].glosa;
                  return Dismissible(
                      // Specify the direction to swipe and delete
                      direction: DismissDirection.startToEnd,
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        // Removes that item the list on swipwe
                        setState(() {
                          _itemsOrderDetail.removeAt(index);
                        });
                        // Shows the information on Snackbar
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("$itemName eliminado")));
                      },
                      background: Container(color: Colors.red.shade300),
                      child: Column(key: Key('$index'), children: [
                        ListTile(
                            minVerticalPadding: 10,
                            tileColor: _itemsOrder[index].isOdd
                                ? oddItemColor
                                : evenItemColor,
                            title: Text(
                                "${(_itemsOrderDetail.length > 0) ? _itemsOrderDetail[index].glosa : ''}\n\nPrecio: \$ ${(_itemsOrderDetail[index].precio != null) ? _itemsOrderDetail[index].precio : '0'}",
                                style: TextStyle(fontSize: 14)),
                            subtitle: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Flexible(
                                        child: new Text(
                                          "${_itemsOrderDetail[index].comentario}\n",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                      )
                                    ]),
                                    Row(children: [
                                      Text(
                                        'Cant.: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Expanded(
                                        child: Text(
                                            (_itemsOrderDetail.length > 0)
                                                ? double.parse(
                                                        _itemsOrderDetail[index]
                                                            .cantidad)
                                                    .toStringAsFixed(1)
                                                : ''),
                                      ),
                                      Text(
                                        ' ${(_itemsOrderDetail.length > 0) ? _itemsOrderDetail[index].unidadIngreso : ''}',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ]),
                                  ],
                                ))),
                        Divider(
                          color: Colors.red.shade900,
                        )
                      ]));
                }))
      ],
    );
  }

  void _checkList() {
    //TODO: parsear maps con solo los datos necesarios
    Map<String, dynamic> saveData = new Map<String, dynamic>();

    final f = new DateFormat('dd/MM/yyyy');
    var fchEmis = f.format(_dteData.data.head.fchEmis);

    saveData.addAll({
      'head': {
        'folio': _dteData.data.head.dteFolio,
        'rut_proveedor': _dteData.data.head.rutEmisor,
        'usuario_recepciona': '',
        'id_dte': '',
        'numero_oc': _dteData.data.head.ref,
        'fecha_emision': fchEmis,
        'usuario': 'app'
      }
    });

    List<dynamic> detailDte = List<dynamic>();
    var ocDet = _itemsOrderDetail.asMap();
    var inxDet = 0;
    _itemsDetail.forEach((element) {
      var det = {
        'codigo_proveedor': element.vlrCodigo,
        'glosa_proveedor': element.nmbItem,
        'cantidad': element.qtyItem, //TODO: cantidad ingresada
        'linea': element.nroLinDet,
        'oc_codigo': ocDet[inxDet].codigoProducto,
        'oc_glosa': ocDet[inxDet].glosa
      };
      detailDte.add(det);
      inxDet++;
    });

    saveData.addAll({'detail': detailDte});
    //saveData.addAll({'order': _itemsOrderDetail});
    _showMyDialogManual(context, jsonEncode(saveData));
  }

  Future<void> _showMyDialogManual(
      BuildContext context, String saveData) async {
    return showDialog<void>(
      context: context,
      builder: (_) => FunkyOverlayManual(saveData),
    );
  }

  Future<DteModel> _searchPendantReceptions(String rut, String folio) async {
    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteDetail(rut, folio, 52);
    return _dte;
  }

  Future<PurchaseOrderModel> _searchPurchaseOrder(String num_oc) async {
    ReceptionProvider reception = new ReceptionProvider();
    PurchaseOrderModel _porder = await reception.getOc(num_oc);

    return _porder;
  }

  Widget _generateItemList(Item dteItem, int index) {
    int lineNumber = index++;

    return Container(
        key: Key('$index'),
        color: Colors.grey.shade300,
        //padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        child: Column(children: [
          ListTile(
            leading: Text(
              lineNumber.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            title: Text(dteItem.nmbItem),
            subtitle: Row(children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    hintStyle: TextStyle(color: Colors.orange.shade300),
                    labelStyle: TextStyle(color: Colors.orange.shade900),
                  ),
                  readOnly: false,
                  initialValue: dteItem.qtyItem,
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(dteItem.unmdItem,
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            ]),
          )
        ]));
  }

  Widget _generateOrderDetailList(Detail dteItem, int index) {
    int lineNumber = index++;

    return Container(
        key: Key('$index'),
        color: Colors.grey.shade300,
        //padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5.0),
        child: Column(children: [
          ListTile(
            leading: Text(
              lineNumber.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            title: Text(dteItem.glosa),
            subtitle: Row(children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    hintStyle: TextStyle(color: Colors.orange.shade300),
                    labelStyle: TextStyle(color: Colors.orange.shade900),
                  ),
                  readOnly: false,
                  initialValue: dteItem.cantidad,
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(dteItem.unidadIngreso,
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            ]),
          )
        ]));
  }
}

class FunkyOverlayManual extends StatefulWidget {
  String _saveData;

  FunkyOverlayManual(String saveData) {
    this._saveData = saveData;
  }

  @override
  State<StatefulWidget> createState() =>
      FunkyOverlayStateManual(this._saveData);
}

class FunkyOverlayStateManual extends State<FunkyOverlayManual>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  final TextEditingController _rut = new TextEditingController();
  final TextEditingController _folio = new TextEditingController();
  ReceptionProvider receptionProvider = new ReceptionProvider();

  String _saveData;

  FunkyOverlayStateManual(String saveData) {
    this._saveData = saveData;
  }
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildAlertDialog();
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: Text('Guardar Datos'),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text('¿Desea Guardar estos datos?')]),
      actions: <Widget>[
        AsyncButtonBuilder(
          child: Text('Aceptar'),
          onPressed: () async {
            await _saveReception(this._saveData).then((value) => {
                  if (value != null)
                    {
                      Fluttertoast.showToast(
                          msg: "Datos almacenados Correctamente!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0),
                      setState(() {
                        Navigator.of(context).pop();

                        Navigator.pushNamed(context, '/reception_resumen',
                            arguments: fullArgumentsResumen(this._saveData));
                      }),
                    }
                  else
                    {
                      Fluttertoast.showToast(
                          msg: "Error al guardar datos!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0),
                      setState(() {
                        Navigator.of(context).pop();
                      }),
                    }
                });
          },
          builder: (context, child, callback, _) {
            return TextButton(
              onPressed: callback,
              child: child,
            );
          },
        ),
        FlatButton(
            child: Text("Cancelar"),
            textColor: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Future<ReceptionResponse> _saveReception(String saveData) async {
    ReceptionResponse response =
        await receptionProvider.saveReception(saveData);
    return response;
  }
}
