import 'package:eagon_bodega/src/pages/navdrawer_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

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
      body: _createHorizontalView(context)//_homeView(),
    );
  }

  Widget _createFormOrders(BuildContext context){
    return Form(
      key: _formKey,
      child :
        Container(
          width: 500,
          margin: EdgeInsets.all(10),
          child:
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                Expanded(
                  child: 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        _createNumberInput(),
                        _createProviderInput(),
                        //_createSubmitButton(context)
                      ]
                    )
                )
              ],
            )
        ) 
      );
  }
  
  Widget _createHorizontalView(context){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.0),
    //height: 538.0,
    child:   
      Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 1.0),
            child: new Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: new Padding(
                      padding: new EdgeInsets.only(left: 8.0),
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                              'Recepciones Pendientes',
                                style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),  
                            ),
                            Row(
                              children : [ _createSearchButton(context, 'orders')]
                            )
                          ],
                        )
                      ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  height: 170.0,
                  child:
                    ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 300.0,
                        //color: Colors.red,
                        child: _pendingReception(context),
                        //padding: EdgeInsets.symmetric(horizontal: 10.0),
                        margin: EdgeInsets.only(left:10),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.blue,
                        child: _pendingReception(context),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.green,
                        child: _pendingReception(context),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.yellow,
                        child: _pendingReception(context),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.orange,
                        child: _pendingReception(context),
                        
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.red,
                ),
                Align(
                  alignment: Alignment.center,
                  child: new Padding(
                      padding: new EdgeInsets.only(left: 8.0),
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                              'Pedidos Pendientes',
                                style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),  
                            ),
                            Row(
                              children : [ _createSearchButton(context, 'delivery')]
                            )
                          ],
                        )
                      ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  height: 170.0,
                  child:
                    ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 300.0,
                        //color: Colors.red,
                        child: _pendingDelivery(),
                        //padding: EdgeInsets.symmetric(horizontal: 10.0),
                        margin: EdgeInsets.only(left:10),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.blue,
                        child: _pendingDelivery(),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.green,
                        child: _pendingDelivery(),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.yellow,
                        child: _pendingDelivery(),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.orange,
                        child: _pendingDelivery(),
                        
                      ),
                    ],
                  ),
                ),
              ],
            )
          )
        ]
      )  
  );
}

  Widget _createNumberInput(){
      return TextFormField(
        style: TextStyle(color: Colors.black, fontSize: 13.0),
        decoration: const InputDecoration(
          hintText: 'Número documento',
          contentPadding: EdgeInsets.all(20.0),
          isDense: true,
        ),
        validator: (value){
          if(value.isEmpty){
            return 'Número Inválido';
          }
          return null;
        },
        onSaved: (String value) {

        },
      );
    }

  Widget _createProviderInput(){
      return TextFormField(
        style: TextStyle(color: Colors.black, fontSize: 13.0),
        decoration: const InputDecoration(
          hintText: 'Rut Proveedor',
          contentPadding: EdgeInsets.all(20.0),
          isDense: true,
        ),
        validator: (value){
          if(value.isEmpty){
            return 'Rut inválido';
          }
          return null;
        },
        onSaved: (String value) {
          
        },
      );
    }

  Widget _createSearchButton(BuildContext context, String dialog){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.orange
      ),
      onPressed: (){
        switch (dialog) {
          case 'orders':{
            _showOrderDialog(context);
          }
          break;
          case 'delivery':{
            _showDeliveryDialog(context);
          }
          break;
          // ignore: unnecessary_statements
          default: {new Row();};
          break;
        }
      }, 
      child: Icon(Icons.search)
    );
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
                child: new Text('')
              ),
          ),
          ListTile(
            leading: Icon(Icons.delivery_dining, color: Colors.deepOrange),
            title: Text('Entrega N° 123432'),
            subtitle: Text('Usuario : Juan C. Torres \nFecha Entrega : 01-01-2021'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: (){}, 
                child: Text('Posponer')
              ),
              TextButton(
                onPressed: (){}, 
                child: Text('Entregar')
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _pendingReception(BuildContext context) {
    return Card(
      
      color: Colors.amber.shade100,
      shadowColor: Colors.grey,
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: new Padding(
                  padding: new EdgeInsets.only(left: 8.0, top: 8.0),
                  child: new Text('')
                ),
            ),
          ListTile(
            leading: Icon(Icons.online_prediction_sharp, color: Colors.amberAccent.shade700),
            title: Text('Recepcion N° 123432'),
            subtitle: Text('Proveedor : EAGON LAUTARO \nFecha Emisión : 01-01-2021'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: (){}, 
                child: Text('Posponer')
              ),
              TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/reception');
                }, 
                child: Text('Recepcionar')
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showOrderDialog(BuildContext context) async{
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
                  ),
                  TextFormField(
                    validator: (value){
                      return value.isNotEmpty? null: "Rut Inválido";
                    },
                    decoration: InputDecoration(hintText: "ex : 77407770-7"),
                  ),
                ],
              ),
            ),
            title: Text("Buscar documento"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange
                ),
                onPressed: (){
                  //_showOrderDialog(context);
                }, 
                child: Text("Buscar")
              )
            ],
          );
        });
      });
  }

  
  Future<void> _showDeliveryDialog(BuildContext context) async{
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
                  )
                ],
              ),
            ),
            title: Text("Buscar Pedido"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange
                ),
                onPressed: (){
                  //_showOrderDialog(context);
                }, 
                child: Text("Buscar")
              )
            ],
          );
        });
      });
  }
}
