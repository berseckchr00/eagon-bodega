import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:flutter/material.dart';

class ReceptionPage extends StatefulWidget{
  
  @override
  _OrdersPageState createState() => new _OrdersPageState();

}

class _OrdersPageState extends State<ReceptionPage>{

  int currentStep = 0;
  bool complete = false;
  Item item;

  List<Step> steps;
  
  
  @override
  Widget build(BuildContext context) {

    this.item = ModalRoute.of(context).settings.arguments;

    return new Scaffold(
      appBar: AppBar(
        title: Text('Recepción'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stepper(
              type: StepperType.vertical,
              steps : steps,
              currentStep: currentStep,
              onStepContinue: next,
              onStepTapped: (step)=>goTo(step),
              onStepCancel: cancel,
          ))
        ]
      ),
    );
  }

  @override
  void initState() { 
    super.initState();
    _searchPendantReceptions(item.rutEmisor, item.dteFolio).then((value) => 
      setState(() {
        steps = _createSteps(value);
      })
    );
  }

  next(){
    currentStep + 1 != steps.length
      ?goTo(currentStep + 1)
      :setState(()=> complete = true);
  }

  cancel(){
    if(currentStep > 0){
      goTo(currentStep -1);
    }
  }

  goTo(int step){
    setState(() => currentStep = step);
  }

  Future<DteModel> _searchPendantReceptions(String rut, String folio) async{
    ReceptionProvider reception = new ReceptionProvider();
    DteModel _dte = await reception.getDteDetail(rut, folio);  
    return _dte;
  }

  List<Step> _createSteps(DteModel dte){

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
        )
      ),
      Step(
        title: const Text('Datos documento'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: _createDetail(detail)
        )
      ),
      Step(
        title: const Text('Detalle OC'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Item'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Cantidad'),
            )
          ],
        )
      )
    ];

    return steps;
  }

  TextFormField _createTextStep(String label, String value, bool readOnly){
    return TextFormField(
        decoration: InputDecoration(labelText: label),
        readOnly: readOnly,
        initialValue: value,
      );
  }

  List<Widget> _createDetail(List<Item> items){
    List<Widget> det;

    items.forEach((element) {
      det.add(_createTextStep('Item',
              element.vlrCodigo + ' '+ element.dscItem, 
              true
      ));
    });

    return det;
  }
}