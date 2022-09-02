/// Flutter code sample for ReorderableListView

import 'dart:convert';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/models/reception_response.dart';
import 'package:eagon_bodega/src/models/warehouse_model.dart';
import 'package:eagon_bodega/src/pages/allocation/allocation_dte.dart';
import 'package:eagon_bodega/src/pages/receptions/resume/reception_resumen.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:eagon_bodega/src/providers/warehause_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AllocationArguments {
  final DteModel detailReception;
  final WareHouseModel warehouseData;

  AllocationArguments(this.detailReception, this.warehouseData);
}

/// This is the main application widget.
class AllocationOrderList extends StatefulWidget {
  AllocationOrderList({Key key}) : super(key: key);

  @override
  _AllocationOrderState createState() {
    return _AllocationOrderState();
  }
}

// This is the private State class that goes with MyStatefulWidget.
class _AllocationOrderState extends State<AllocationOrderList> {
  List<int> _items = [];
  List<Item> _itemsDetail = [];
  DteModel _dteData;

  WareHouseModel wareHouseModel;
  List<WareHouseModel> listWarehouse = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool rebuild = false;

  @override
  Widget build(BuildContext context) {
    String _title = 'Asignación Detalle/Ubicación';
    final dteargs =
        ModalRoute.of(context).settings.arguments as AllocationArguments;

    _dteData = dteargs.detailReception;
    wareHouseModel = dteargs.warehouseData;
    if (_defaultWarehouse.isEmpty) {
      _poolListDte(_dteData);
    }

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
        body: (listWarehouse.isNotEmpty)
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
                    ],
                  ),
                  Expanded(child: _createList(rebuild)),
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

  List<int> _defaultWarehouse = []; //dejar como listas
  int _defaultWarehouseAreas = null;
  int _defaultWarehouseAreasStreets = null;
  int _defaultWarehouseAreasStreetsSide = null;
  int _defaultWarehouseAreasLocation = null;

  void _poolListDte(DteModel _dte) {
    _itemsDetail = _dte.data.items;
    _items = List<int>.generate(_itemsDetail.length, (int index) => index);

    for (var item in _dte.data.items) {
      listWarehouse.add(wareHouseModel);
    }
  }

  Widget _createList(bool rebuild) {
    Color oddItemColorDetail = Colors.orange[200];
    Color evenItemColorDetail = Colors.grey[200];

    //_defaultWarehouse.clear();
    Map<String, int> warehouse = {};

    for (var item in listWarehouse) {
      if (item != null) {
        for (var det in item.data) {
          warehouse[det.nombre] = int.parse(det.idBodega);
        }

        if (!rebuild) {
          _defaultWarehouse.add(int.parse(item.data.elementAt(0).idBodega));
        }
      }
    }

    const Map<String, int> warehouseAreas = {
      "ZONA A": 1,
      "ZONA EXTRA": 3,
      "ENCARPADO": 6
    };

    const Map<String, int> warehouseAreasStreets = {
      "CALLE 1": 1,
      "CALLE 2": 2,
      "CALLE 10": 10
    };

    const Map<String, int> warehouseAreasSide = {"LADO A": 0, "LADO B": 1};

    const Map<String, int> warehouseAreasLocation = {
      "0_0_1": 308,
      "0_1_1": 309,
      "1_1_1": 311
    };

    return Row(children: [
      Expanded(
          child: ListView(children: [
        for (int index = 0; index < _items.length; index++)
          //_generateItemList(_itemsDetail[index], index)
          Column(
            key: Key('$index'),
            children: [
              Card(
                borderOnForeground: true,
                color: _items[index].isOdd
                    ? oddItemColorDetail
                    : evenItemColorDetail,
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 200,
                              child: Text('${_itemsDetail[index].nmbItem}')),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Cant.: ',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 50.0,
                                child: TextFormField(
                                    initialValue: double.parse(
                                            _itemsDetail[index].qtyItem)
                                        .toString(),
                                    style: TextStyle(fontSize: 14.0),
                                    readOnly: true,
                                    textAlign: TextAlign.left),
                              ),
                              Text(
                                ' ${_itemsDetail[index].unmdItem}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            padding: EdgeInsets.zero,
                            child: new DropdownButton<int>(
                              hint: Text("Selecciona un valor"),
                              items: warehouse
                                  .map((model, value) {
                                    return MapEntry(
                                        model,
                                        DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(model),
                                        ));
                                  })
                                  .values
                                  .toList(),
                              value: _defaultWarehouse[index],
                              onChanged: (int newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _defaultWarehouse[index] = newValue;
                                    print(_defaultWarehouse[index]);
                                    this.rebuild = true;
                                    //TODO: call api
                                  });
                                }
                              },
                            )),
                        Container(
                            padding: EdgeInsets.zero,
                            child: new DropdownButton<int>(
                              hint: Text("Selecciona un valor"),
                              items: warehouseAreas
                                  .map((description, value) {
                                    return MapEntry(
                                        description,
                                        DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(description),
                                        ));
                                  })
                                  .values
                                  .toList(),
                              value: _defaultWarehouseAreas,
                              onChanged: (int newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    print(newValue);
                                    _defaultWarehouseAreas = newValue;
                                  });
                                }
                              },
                            )),
                        Container(
                            padding: EdgeInsets.zero,
                            child: new DropdownButton<int>(
                              hint: Text("Selecciona un valor"),
                              items: warehouseAreasStreets
                                  .map((description, value) {
                                    return MapEntry(
                                        description,
                                        DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(description),
                                        ));
                                  })
                                  .values
                                  .toList(),
                              value: _defaultWarehouseAreasStreets,
                              onChanged: (int newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    print(newValue);
                                    _defaultWarehouseAreasStreets = newValue;
                                  });
                                }
                              },
                            )),
                        Container(
                            padding: EdgeInsets.zero,
                            child: new DropdownButton<int>(
                              hint: Text("Selecciona un valor"),
                              items: warehouseAreasSide
                                  .map((description, value) {
                                    return MapEntry(
                                        description,
                                        DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(description),
                                        ));
                                  })
                                  .values
                                  .toList(),
                              value: _defaultWarehouseAreasStreetsSide,
                              onChanged: (int newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    print(newValue);
                                    _defaultWarehouseAreasStreetsSide =
                                        newValue;
                                  });
                                }
                              },
                            )),
                        Container(
                            padding: EdgeInsets.zero,
                            child: new DropdownButton<int>(
                              hint: Text("Selecciona un valor"),
                              items: warehouseAreasLocation
                                  .map((description, value) {
                                    return MapEntry(
                                        description,
                                        DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(description),
                                        ));
                                  })
                                  .values
                                  .toList(),
                              value: _defaultWarehouseAreasLocation,
                              onChanged: (int newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    print(newValue);
                                    _defaultWarehouseAreasLocation = newValue;
                                  });
                                }
                              },
                            ))
                      ],
                    ),
                  )
                ]),
              ),
              Divider(
                color: Colors.grey.shade900,
              )
            ],
          )
      ]))
    ]);
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
    var inxDet = 0;
    _itemsDetail.forEach((element) {
      var det = {
        'codigo_proveedor': element.vlrCodigo,
        'glosa_proveedor': element.nmbItem,
        'cantidad': element.qtyItem, //TODO: cantidad ingresada
        'linea': element.nroLinDet,
      };
      detailDte.add(det);
      inxDet++;
    });

    saveData.addAll({'detail': detailDte});
    //saveData.addAll({'order': _itemsOrderDetail});
    _showMyDialogManual(context, jsonEncode(saveData));
  }

  Future<WareHouseModel> _getWarehouseList() async {
    WareHouseProvider warehouseProvider = new WareHouseProvider();
    WareHouseModel warehouseModel = await warehouseProvider.getWareHouseList();

    return warehouseModel;
  }

  Future<void> _showMyDialogManual(
      BuildContext context, String saveData) async {
    return showDialog<void>(
      context: context,
      builder: (_) => FunkyOverlayManual(saveData),
    );
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
