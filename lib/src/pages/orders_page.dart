import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget{
  
  @override
  _OrdersPageState createState() => new _OrdersPageState();

}

class _OrdersPageState extends State<OrdersPage>{

  int currentStep = 0;
  bool complete = false;

  List<Step> steps = [
    Step(
      title: const Text('Datos generales'),
      isActive: true,
      state: StepState.complete,
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Cantidad'),
          )
        ],
      )
    ),
    Step(
      title: const Text('Datos documento'),
      isActive: true,
      state: StepState.complete,
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Direccion'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Proveedor'),
          )
        ],
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Recepción'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Stepper(
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
  
}