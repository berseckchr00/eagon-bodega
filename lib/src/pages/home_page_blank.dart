import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/pages/navdrawer_page.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:eagon_bodega/src/shared_preferences/user_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, String> _formData = {'rut': null, 'folio': null};
  final _formKey = GlobalKey<FormState>();
  final prefs = new PreferenciasUsuario();
  List<Widget> _cardReception;

  var folioDte = 0;
  var rutDte = "";

  bool submitting = false;

  void _toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }

  @override
  void initState() {
    super.initState();
    //if(prefs.ciSession != null) Navigator.pushNamed(context, '/login');
    // _loadPendantReceptions().then((value) => setState(() {
    //       _cardReception = value;
    //     }));
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _loadPendantReceptions().then((value) => setState(() {
    //       _cardReception = value;
    //     }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
            title: Text('EAGON Bodega'),
            centerTitle: true,
            backgroundColor: Colors.orange
            //leading: Icon(Icons.menu)
            ),
        //body: _createLista(),
        body: (!submitting)
            ? _createHorizontalView(context)
            : const Center(
                child: const CircularProgressIndicator()) //_homeView(),
        );
  }

  Widget _createFormOrders(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            width: 500,
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      _createNumberInput(),
                      _createProviderInput(),
                      //_createSubmitButton(context)
                    ]))
              ],
            )));
  }

  Widget _createHorizontalView(context) {
    return Container();
  }

  Widget _createNumberInput() {
    return TextFormField(
      style: TextStyle(color: Colors.black, fontSize: 13.0),
      decoration: const InputDecoration(
        hintText: 'Número documento',
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Número Inválido';
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _createProviderInput() {
    return TextFormField(
      style: TextStyle(color: Colors.black, fontSize: 13.0),
      decoration: const InputDecoration(
        hintText: 'Rut Proveedor',
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Rut inválido';
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _createSearchButton(BuildContext context, String dialog) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.orange),
        onPressed: () {
          switch (dialog) {
            case 'orders':
              {
                _showOrderDialog(context);
              }
              break;
            case 'delivery':
              {
                _showDeliveryDialog(context);
              }
              break;
            // ignore: unnecessary_statements
            default:
              {
                new Row();
              }
              ;
              break;
          }
        },
        child: Icon(Icons.search));
  }

  Widget _pendingDelivery() {
    return Card(
      color: Colors.grey.shade200,
      shadowColor: Colors.grey,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: new Padding(
                padding: new EdgeInsets.only(left: 8.0, top: 8.0),
                child: new Text('')),
          ),
          ListTile(
            leading: Icon(Icons.delivery_dining, color: Colors.deepOrange),
            title: Text('Entrega N° 123432'),
            subtitle:
                Text('Usuario : Juan C. Torres \nFecha Entrega : 01-01-2021'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(onPressed: () {}, child: Text('Posponer')),
              TextButton(onPressed: () {}, child: Text('Entregar'))
            ],
          )
        ],
      ),
    );
  }

  Widget _pendingReception(BuildContext context, Item item) {
    final f = new DateFormat('dd/MM/yyyy');

    var fchEmis = f.format(item.fchEmis);

    return Card(
      color: Colors.amber.shade100,
      shadowColor: Colors.grey,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: new Padding(
                padding: new EdgeInsets.only(left: 8.0, top: 8.0),
                child: new Text('')),
          ),
          ListTile(
            leading: Icon(Icons.online_prediction_sharp,
                color: Colors.amberAccent.shade700),
            title: Text('Recepcion N° ${item.dteFolio}'),
            subtitle:
                Text('Proveedor :${item.rznSoc} \nFecha Emisión :$fchEmis'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(onPressed: () {}, child: Text('Posponer')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reception', arguments: item);
                  },
                  child: Text('Recepcionar'))
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showOrderDialog(BuildContext context) async {
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Número Inválido";
                      },
                      decoration: InputDecoration(hintText: "ex : 123456789"),
                      onSaved: (String value) {
                        _formData['folio'] = value;
                        this.folioDte = int.parse(value);
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        return value.isNotEmpty ? null : "Rut Inválido";
                      },
                      decoration: InputDecoration(hintText: "ex : 77407770-7"),
                      onSaved: (String value) {
                        _formData['rut'] = value;
                        this.rutDte = value;
                      },
                    ),
                  ],
                ),
              ),
              title: Text("Buscar documento"),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        //ReceptionProvider().getDteDetail(_formData['rut'], _formData['folio']);
                        _searchPendantReceptions(
                                _formData['rut'], _formData['folio'])
                            .then((value) => this.setState(() {
                                  _cardReception = value;
                                }));
                      }
                    },
                    child: Text("Buscar"))
              ],
            );
          });
        });
  }

  void _showDeliveryDialog(BuildContext context) async {
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Número Inválido";
                      },
                      decoration: InputDecoration(hintText: "ex : 123456789"),
                    )
                  ],
                ),
              ),
              title: Text("Buscar Pedido"),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    onPressed: () {
                      //_showOrderDialog(context);
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                      }
                    },
                    child: Text("Buscar"))
              ],
            );
          });
        });
  }

  Future<List<Widget>> _loadPendantReceptions() async {
    _toggleSubmitState();
    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteList();
    List<Widget> _boxes;

    if (_dte != null && _dte.data.items != null) {
      _boxes = _setBoxes(_dte.data.items);
    }

    _toggleSubmitState();
    return _boxes;
  }

  Future<List<Widget>> _searchPendantReceptions(
      String rut, String folio) async {
    _toggleSubmitState();
    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteDetail(rut, folio, 52);
    List<Widget> _boxes;
    List<Item> items = [];

    if (_dte != null && _dte.data.items != null) {
      Head head = _dte.data.head;
      _dte.data.items.forEach((element) {
        Item item = Item.fromJson(element.toJson());
        item.fchEmis = head.fchEmis;
        item.rznSoc = head.rznSoc;
        item.dteFolio = head.dteFolio;
        items.add(item);
      });

      _boxes = _setBoxes(items);
    }
    _toggleSubmitState();
    return _boxes;
  }

  List<Widget> _setBoxes(List<Item> items) {
    List<Widget> boxes = [];
    items.forEach((element) {
      final content = Container(
        width: 360.0,
        //color: Colors.red,
        child: _pendingReception(context, element),
        //padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.only(left: 10),
      );

      boxes.add(content);
    });

    return boxes;
  }
}
