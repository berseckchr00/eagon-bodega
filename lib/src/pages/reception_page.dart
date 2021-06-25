import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/models/purchase_order_model.dart' as order;
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:flutter/material.dart';

class ReceptionPage extends StatefulWidget{
  
  @override
  _OrdersPageState createState() => new _OrdersPageState();

}

class _OrdersPageState extends State<ReceptionPage>{

  final _formKey = GlobalKey<FormState>();
  final _folio =  '65778';
  final _rut = '96817490-8';
  int currentStep = 0;
  bool complete = false;
  Item item;

  List<Step> steps;
  Stepper stepper;
  
  
  @override
  Widget build(BuildContext context) {

    this.item = ModalRoute.of(context).settings.arguments;
    List<Step> stepDummy = _createStepsDummy();
    
    return new Scaffold(
      appBar: AppBar(
        title: Text('Recepción'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stepper(
              currentStep: currentStep,
              onStepContinue: onStepContinue,
              onStepTapped: (step)=>onStepGoTo(step),
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
                      onPressed: onStepContinue,
                      child: Text('Siguiente'),
                    ),
                  ],
                );
              },
              steps: (steps != null)?steps:_createStepsDummy(),
            )
          )
        ]
      ),
    );
  }

  @override
  void initState() { 
    super.initState();
    /*this.item = ModalRoute.of(context).settings.arguments;*/
    _searchPendantReceptions(this._rut, this._folio).then((value) => 
      {
        if(value.data.head.ref != null){
          _searchPurchaseOrder(value.data.head.ref).then((oc_data) => {
          
            setState(() {
              steps = _createSteps(context, value, oc_data);
            })
          })
        }else{
          setState(() {
            steps = _createSteps(context, value, null);
          })
        }
        
      }
    );
  }

  onStepContinue(){
    currentStep + 1 != steps.length
      ?onStepGoTo(currentStep + 1)
      :setState(()=> complete = true);
  }

  onStepCancel(){
    if(currentStep > 0){
      onStepGoTo(currentStep -1);
    }
  }

  onStepGoTo(int step){
    setState(() => currentStep = step);
  }

  Future<DteModel> _searchPendantReceptions(String rut, String folio) async{
    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteDetail(rut, folio);  

    
    return _dte;
  }

  List<Step> _createSteps(BuildContext context, DteModel dte, order.PurchaseOrderModel oc){

      Head data = dte.data.head;
      List<Item> detail = dte.data.items;

      List<Step> steps = [
      Step(
        title: const Text('Datos generales'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: <Widget>[
            _createTextStep('Folio',data.dteFolio, true),
            _createTextStep('Rut Emisor',data.rutEmisor, true),
            _createTextStep('Razón Social',data.rznSoc, true),
            _createTextStep('Fecha Emisión',data.fchEmis.toString(), true),
            _createTextStep('Dirección Origen',data.dirOrigen, true)
          ],
        ),
      ),
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
                onPressed: (){
                  _showDeliveryDialog(context);
                },
                child: Icon(Icons.search)
              ),
            ],
            ),
            _createTextStep('Numero',(oc != null)?oc.data.head.numero:'', true),
            _createTextStep('Fecha',(oc != null)?oc.data.head.fecha.toString():'', true),
            _createTextStep('Porcentaje Asignado',(oc != null)?oc.data.head.porcentajeAsignado:'', true),
          ],
        )
      ),
      Step(
        title: const Text('Detalle documento'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: _createDetail(context,detail, oc)
        )
      ),
    ];

    return steps;
  }

  List<Step> _createStepsDummy(){

    List<Step> steps = [
      Step(
        title: const Text('Datos generales'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: []
        )
      ),
      Step(
        title: const Text('Detalle OC'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: []
        )
      ), Step(
        title: const Text('Datos documento'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: []
        )
      ),
    ];

    return steps;
  }
  TextFormField _createTextStep(String label, String value, bool readOnly, {bool multiline = false}){
    return (multiline)? TextFormField(
        decoration: InputDecoration(labelText: label),
        readOnly: readOnly,
        initialValue: value,
      ):
      TextFormField(
        decoration: InputDecoration(labelText: label),
        readOnly: readOnly,
        initialValue: value,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      );
  }

  List<Widget> _createDetail(BuildContext conext, List<Item> items, order.PurchaseOrderModel oc){
    List<Widget> _det = [];
    List<order.Detail> _detOc = (oc != null)?oc.data.details:null;
    DropdownButton dp;

    items.forEach((element) {
      String item = element.vlrCodigo + ' - '
              +element.nmbItem;

      if (oc != null){
        // acá agregamos el select para la oc
        //String _value = oc.data.details[0].codigoProducto;
        int _value = 1;
        List<String> _lstDetailOc = [];
        _detOc.forEach((element) {
          _lstDetailOc.add(element.codigoProducto);
        });

        dp = new DropdownButton<String>(
            //value: _value,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.grey,
            ),
            items: _lstDetailOc
            .map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value)
              );
            }).toList(),
            onChanged: (selectedValue) {
                print(selectedValue);
                setState(() {
                  for (int i = 0; i < _lstDetailOc.length; i++)
                    if (_lstDetailOc[i] == selectedValue) {
                      _value = i + 1;
                    }
                  //hintValue = "Steuerklasse $selectedValue";
                  return _value;
                });
              },
          );          
      }

      Row row = new Row(
            children: [
              Expanded(
                child: 
                TextFormField(
                  decoration: InputDecoration(labelText: 'Item', ),
                  readOnly: true,
                  initialValue: element.nmbItem,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 12
                  ),
                )
              ),
              Expanded(child: 
                 TextFormField(
                  decoration: InputDecoration(labelText: 'Cantidad'),
                  readOnly: false,
                  initialValue: element.qtyItem,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 12
                  ),
                )
              ),
              Expanded(
                child: 
                 TextFormField(
                  decoration: InputDecoration(labelText: 'Un. Medida'),
                  readOnly: true,
                  initialValue: element.unmdItem,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 12
                  ),
                )
              )
            ],
          );

      _det.add(row);
      _det.add(dp);
    });

    return _det;
  }



  Future<order.PurchaseOrderModel> _searchPurchaseOrder(String num_oc) async{
    ReceptionProvider reception = new ReceptionProvider();
    order.PurchaseOrderModel _porder = await reception.getOc(num_oc);

    return _porder;
  }

  void _showDeliveryDialog(BuildContext context) async{
    String _ocNumber;

    return await showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(builder: (conext, setState){
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number, 
                    validator: (value){
                      return value.isNotEmpty? null: "Número Inválido";
                    },
                    decoration: InputDecoration(hintText: "ex : 123456789"),
                    onSaved: (String value){
                      _ocNumber = value;
                    },
                  )
                ],
              ),
            ),
            title: Text("Buscar Order de Compra"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange
                ),
                onPressed: (){
                  //_showOrderDialog(context);
                  if (_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    _searchPurchaseOrder(_ocNumber).then((value) => {
                       _searchPendantReceptions(this._rut, this._folio).then((dte) => 
                        setState(() {
                          steps = _createSteps(context, dte, value);
                        })
                      )
                    });
                  }                    
                }, 
                child: Text("Buscar")
              )
            ],
          );
        });
      });
  }
}