import 'package:async_button_builder/async_button_builder.dart';
import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/models/dte_model.dart' as modelDte;
import 'package:eagon_bodega/src/models/purchase_order_model.dart' as order;
import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ReceptionDtePage extends StatefulWidget {
  @override
  _ReceptionPageState createState() => new _ReceptionPageState();
}

class DteArguments {
  final DteModel dteModel;

  DteArguments(this.dteModel);
}

class OcArguments {
  final PurchaseOrderModel ocModel;
  OcArguments(this.ocModel);
}

class fullArguments {
  final DteModel dteModel;
  final PurchaseOrderModel ocModel;
  fullArguments(this.dteModel, this.ocModel);
}

class OrderDetail {
  const OrderDetail(
      this.codigoProducto, this.cantidad, this.codigoProveedor, this.glosa);
  final String codigoProducto;
  final String cantidad;
  final String glosa;
  final String codigoProveedor;
}

class _ReceptionPageState extends State<ReceptionDtePage> {
  final _formKey = GlobalKey<FormState>();
  String _folio;
  String _rut;
  DteModel _dteModel;
  order.PurchaseOrderModel _ocRef;
  int currentStep = 0;
  bool complete = false;
  Item item;

  List<Step> steps;
  Stepper stepper;
  Color _colorDetail;

  bool submitting = false;
  order.PurchaseOrderModel ocData;

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //this.item = ModalRoute.of(context).settings.arguments;

    final args = ModalRoute.of(context).settings.arguments as fullArguments;
    this._dteModel = args.dteModel;
    this._ocRef = args.ocModel;
    if (this._dteModel != null) {
      steps = _createSteps(context, this._dteModel, this._ocRef);
    }

    this._folio = args.dteModel.data.head.dteFolio;
    this._rut = args.dteModel.data.head.rutEmisor;

    return new Scaffold(
      appBar: AppBar(
        title: Text('Recepción'),
      ),
      body: Column(children: <Widget>[
        Expanded(
            child: Stepper(
          currentStep: currentStep,
          onStepContinue: onStepContinue(),
          onStepTapped: (step) => onStepGoTo(step),
          onStepCancel: onStepCancel,
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Row(
              children: <Widget>[
                TextButton(
                  onPressed: onStepCancel,
                  child: Text('Anterior'),
                ),
                TextButton(
                  onPressed: (!complete)
                      ? onStepContinue
                      : () {
                          if (ocData == null) {
                            Fluttertoast.showToast(
                                msg: "Orden de Compra vacía",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            Navigator.pushNamed(context, '/reception_list',
                                arguments: fullArguments(_dteModel, ocData));
                          } else {
                            Navigator.pushNamed(context, '/reception_list',
                                arguments: fullArguments(_dteModel, ocData));
                          }
                        },
                  child: Text('Siguiente'),
                ),
              ],
            );
          },
          steps: (steps != null) ? steps : _createStepsDummy(),
        ))
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    _colorDetail = _getColorCard(false);
  }

  onStepContinue() {
    currentStep + 1 != steps.length
        ? onStepGoTo(currentStep + 1)
        : setState(() {
            complete = true;
          });
  }

  onStepCancel() {
    if (currentStep > 0) {
      onStepGoTo(currentStep - 1);
    }
  }

  onStepGoTo(int step) {
    setState(() => currentStep = step);
  }

  Future<DteModel> _searchPendantReceptions(String rut, String folio) async {
    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteDetail(rut, folio);

    return _dte;
  }

  List<Step> _createSteps(
      BuildContext context, DteModel dte, order.PurchaseOrderModel oc) {
    ocData = oc;
    modelDte.Head data = dte.data.head;
    List<Item> detail = dte.data.items;
    final f = new DateFormat('dd/MM/yyyy');
    var fchEmis = f.format(data.fchEmis);
    var fchEmisOc = (oc != null) ? f.format(oc.data.head.fecha) : '';

    List<Step> steps = [
      Step(
        title: const Text('Datos generales'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: <Widget>[
            _createTextStep('Folio', data.dteFolio, true),
            _createTextStep('Rut Emisor', data.rutEmisor, true),
            _createTextStep('Razón Social', data.rznSoc, true),
            _createTextStep('Fecha Emisión', fchEmis, true),
            _createTextStep('Dirección Origen', data.dirOrigen, true)
          ],
        ),
      ),
      Step(
          title: const Text('Detalle documento'),
          isActive: true,
          state: StepState.complete,
          content: Column(children: _createDetail(context, detail, oc))),
      Step(
          title: const Text('Datos OC'),
          isActive: true,
          state: StepState.complete,
          content: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _showDeliveryDialog(context);
                      },
                      child: Icon(Icons.search)),
                ],
              ),
              _createTextStep(
                  'Numero', (oc != null) ? oc.data.head.numero : '', true),
              _createTextStep('Fecha', (oc != null) ? fchEmisOc : '', true),
              _createTextStep(
                  'Porcentaje Asignado',
                  (oc != null) ? oc.data.head.porcentajeAsignado + ' %' : '0 %',
                  true),
            ],
          ))
    ];

    return steps;
  }

  List<Step> _createStepsDummy() {
    List<Step> steps = [
      Step(
          title: const Text('Datos generales'),
          isActive: true,
          state: StepState.complete,
          content: Column(children: [])),
      Step(
          title: const Text('Datos documento'),
          isActive: true,
          state: StepState.complete,
          content: Column(children: [])),
      Step(
          title: const Text('Detalle OC'),
          isActive: true,
          state: StepState.complete,
          content: Column(children: []))
    ];

    return steps;
  }

  TextFormField _createTextStep(String label, String value, bool readOnly,
      {bool multiline = false}) {
    return (multiline)
        ? TextFormField(
            decoration: InputDecoration(labelText: label),
            readOnly: readOnly,
            initialValue: value,
          )
        : TextFormField(
            decoration: InputDecoration(labelText: label),
            readOnly: readOnly,
            initialValue: value,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          );
  }

  List<Widget> _createDetail(
      BuildContext conext, List<Item> items, order.PurchaseOrderModel oc) {
    List<Widget> _det = [];
    List<order.Detail> _detOc = (oc != null) ? oc.data.details : [];
    List<String> _lstDetailOc = [];
    List<OrderDetail> ocDetail = [];

    items.forEach((element) {
      if (_detOc.isNotEmpty) {
        _detOc.forEach((element) {
          _lstDetailOc.add(element.codigoProducto);
          ocDetail.add(new OrderDetail(element.codigoProducto, element.cantidad,
              element.codigoProveedor, element.glosa));
        });
      }
      _det.add(_createDetailCard(element, ocDetail));
    });

    return _det;
  }

  Color _getColorCard(bool status) {
    return (!status) ? Colors.orange.shade200 : Colors.greenAccent.shade200;
  }

  Widget _createDetailCard(Item it, List<OrderDetail> lstDetailOc) {
    return Card(
        color: _colorDetail,
        child: Column(
          children: [
            ListTile(
                leading: Text(
                  it.nroLinDet,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                title: Text(it.nmbItem),
                subtitle: Row(children: [
                  Text('Tipo Medida | ',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal)),
                  Text(
                    it.unmdItem,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ]),
                trailing: Column(children: [
                  Text('Cantidad'),
                  Text(it.qtyItem,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ])),
          ],
        ));
  }

  Future<order.PurchaseOrderModel> _searchPurchaseOrder(String numOc) async {
    ReceptionProvider reception = new ReceptionProvider();
    order.PurchaseOrderModel _porder = await reception.getOc(numOc);

    return _porder;
  }

  void _showDeliveryDialog(BuildContext context) async {
    TextEditingController _numOc = new TextEditingController();

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (conext, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _numOc,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Número Inválido";
                      },
                      decoration: InputDecoration(hintText: "ex : 123456789"),
                      onSaved: (String value) {},
                    )
                  ],
                ),
              ),
              title: Text("Buscar Order de Compra"),
              actions: [
                AsyncButtonBuilder(
                  child: Text('Buscar'),
                  onPressed: () async {
                    await _searchPurchaseOrder(_numOc.text)
                        .then((value) => {
                              ocData = value,
                              _searchPendantReceptions(this._rut, this._folio)
                                  .then((dte) => {
                                        Fluttertoast.showToast(
                                            msg: "Orden OK!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0),
                                        //TODO: set state not completed
                                        setState(() {
                                          steps =
                                              _createSteps(context, dte, value);
                                        }),
                                        Navigator.of(context).pop()
                                      })
                            })
                        .whenComplete(() => null);
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
          });
        });
  }
}
