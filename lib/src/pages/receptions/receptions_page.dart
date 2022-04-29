import 'dart:convert';

import 'package:eagon_bodega/src/models/Timbre.dart';
import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/pages/receptions/reception_dte.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml2json/xml2json.dart';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:eagon_bodega/src/models/purchase_order_model.dart' as order;

class ReceptionsPage extends StatefulWidget {
  ReceptionsPage({Key key}) : super(key: key);

  @override
  _ReceptionsPageState createState() => _ReceptionsPageState();
}

class _ReceptionsPageState extends State<ReceptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text("Ingreso", style: TextStyle(fontSize: 18)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        _showMyDialog(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 1.5,
                      color: Colors.orange.shade300,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.developer_board,
                            size: 100,
                          ),
                          SizedBox(height: 5),
                          Text("Leer Documento",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        _showMyDialogManual(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 1.5,
                      color: Colors.grey.shade300,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.style_outlined,
                            size: 100,
                          ),
                          SizedBox(height: 5),
                          Text("Búsqueda Manual",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => FunkyOverlay(),
    );
  }

  Future<void> _showMyDialogManual(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => FunkyOverlayManual(),
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayManual extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayStateManual();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  final TextEditingController _otNumber = new TextEditingController();
  Timbre timbre = new Timbre();

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
      title: Text('Lector de Barra'),
      content: TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        controller: _otNumber,
        decoration: const InputDecoration(
          hintText: 'Ejemplo: ...',
          contentPadding: EdgeInsets.all(20.0),
          isDense: true,
        ),
        onChanged: (value) {
          timbre = _parseXML2Json(value);
          _otNumber.text =
              'Folio : ' + timbre.ted.dd.f + ' Rut: ' + timbre.ted.dd.re;
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Error al Leer';
          }
          return null;
        },
        onFieldSubmitted: (String value) {
          timbre = _parseXML2Json(value);
          _otNumber.text = 'Folio : ' + timbre.ted.dd.f;
          if (timbre == null) {
            Fluttertoast.showToast(
                msg: "Click en Validar!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
      ),
      actions: <Widget>[
        AsyncButtonBuilder(
          child: Text('Validar'),
          onPressed: () async {
            timbre = _parseXML2Json(_otNumber.text);
            if (timbre == null) {
              Fluttertoast.showToast(
                  msg: "No se pudo leer el código",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              await _getDteList(timbre).then((dte) {
                if (dte.data != null) {
                  //TODO: call view DTE
                  Navigator.pushNamed(context, '/reception_dte');
                }
              });
            }
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

  Timbre _parseXML2Json(String value) {
    try {
      value = value
          .replaceFirst(
              '<TED xmlns="http://www.sii.cl/SiiDte"version="1.0">', '<TED>')
          .replaceFirst('<TED >', '<TED>')
          .replaceFirst('http://www.sii.cl/SiiDteversion="1.0>', '<TED>')
          .replaceFirst("version=\"1.0\"", "")
          .replaceFirst("version=\"1.0", "")
          .replaceAll("algoritmo=\"SHA1withRSA>", "algoritmo=\"SHA1withRSA\">")
          .replaceFirst("CAF \"", "CAF ")
          .replaceAll("algoritmo=\"SHA1withRSA>", "algoritmo=\"SHA1withRSA\">");
      print(value);

      final myTransformer = Xml2Json();

      myTransformer.parse(value);

      String json = myTransformer.toParker();

      Map<String, dynamic> tmbr = jsonDecode(json);

      return Timbre.fromJson(tmbr);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<DteModel> _getDteList(Timbre timbre) async {
    var folio = timbre.ted.dd.f;
    var rutEmis = timbre.ted.dd.re;

    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteDetail(rutEmis, folio);

    return _dte;
  }
}

class FunkyOverlayStateManual extends State<FunkyOverlayManual>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  final TextEditingController _rut = new TextEditingController();
  final TextEditingController _folio = new TextEditingController();

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
      title: Text('Búsqueda Manual'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            controller: _rut,
            decoration: const InputDecoration(
              hintText: 'Rut Proveedor: ...',
              contentPadding: EdgeInsets.all(20.0),
              isDense: true,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Error al Leer';
              }
              return null;
            },
            onFieldSubmitted: (String value) {
              //TODO: buscar DTE
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            controller: _folio,
            decoration: const InputDecoration(
              hintText: 'Número guía: ...',
              contentPadding: EdgeInsets.all(20.0),
              isDense: true,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Error al Leer';
              }
              return null;
            },
            onFieldSubmitted: (String value) {
              //TODO: buscar DTE
            },
          )
        ],
      ),
      actions: <Widget>[
        AsyncButtonBuilder(
          child: Text('Buscar'),
          onPressed: () async {
            await _getDteList(_rut.text, _folio.text).then((dte) async {
              if (dte.data != null) {
                await _searchPurchaseOrder(dte.data.head.ref).then((ocRef) {
                  Navigator.pushNamed(
                    context,
                    '/reception_dte',
                    arguments: fullArguments(dte, ocRef),
                  );
                });

                // Navigator.pushNamed(
                //   context,
                //   '/reception_test',
                //   arguments: DteArguments(dte),
                // );
              } else {
                Fluttertoast.showToast(
                    msg: "No se pudo encontrar el documento",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
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

  Future<DteModel> _getDteList(rutEmis, folio) async {
    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteDetail(rutEmis, folio);

    return _dte;
  }

  Future<order.PurchaseOrderModel> _searchPurchaseOrder(String num_oc) async {
    ReceptionProvider reception = new ReceptionProvider();
    order.PurchaseOrderModel _porder = await reception.getOc(num_oc);

    return _porder;
  }
}
