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
  order.Detail selectedDetail ;

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
    List<order.Detail> _detOc = (oc != null)?oc.data.details:[];
    List<String> _lstDetailOc = [];

    items.forEach((element) {
      if (_detOc.isNotEmpty){
        _detOc.forEach((element) {
          _lstDetailOc.add(element.codigoProducto);
        }); 
      }
      _det.add(_createDetailCard(element, _detOc));
    });

    return _det;
  }

  Color _getColorCard(bool status){
    return (!status)?Colors.orange.shade200:Colors.greenAccent.shade200;
  }

  Widget _createDetailCard(Item it, List<order.Detail> lstDetailOc){
    return Card(
      color: _getColorCard(false),
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
          ),
          new DropdownButton<order.Detail>(
                hint: new Text(
                    (lstDetailOc.isNotEmpty)?"Seleccione un producto":"Sin OC", 
                    style:  new TextStyle(color: Colors.black)),
                value: selectedDetail,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 24,
                onChanged: (order.Detail newValue) {
                    setState(() {
                        selectedDetail = newValue ;
                        _getColorCard(true);
                        print(selectedDetail.codigoProducto);
                    });
                  },
                items: lstDetailOc.map((order.Detail value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: Text(
                      value.codigoProducto,
                      style: new TextStyle(color: Colors.black))
                  );
                }).toList()
              )
        ],
      )
      
    );
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