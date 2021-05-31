import 'package:eagon_bodega/src/pages/navdrawer_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
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
      body: _createHorizontalView()//_homeView(),
    );
  }

  Widget _homeView(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        //padding: EdgeInsets.all(20),
        children: <Widget>[
          _pendingReception(),
          _pendingReception(),
          _pendingReception()/*,
          Divider(color: Colors.redAccent,),
          _pendingDelivery(),
          _pendingDelivery()*/
        ]
      ),
    );
  }
  
}

Widget _createHorizontalView(){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20.0),
    height: 538.0,
    child:   
      Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: new Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: new Padding(
                      padding: new EdgeInsets.only(left: 8.0),
                      child: new Text(
                        'Recepciones Pendientes',
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal
                        ),
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
                        child: _pendingReception(),
                        //padding: EdgeInsets.symmetric(horizontal: 10.0),
                        margin: EdgeInsets.only(left:10),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.blue,
                        child: _pendingReception(),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.green,
                        child: _pendingReception(),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.yellow,
                        child: _pendingReception(),
                      ),
                      Container(
                        width: 300.0,
                        //color: Colors.orange,
                        child: _pendingReception(),
                        
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
                      padding: new EdgeInsets.only(left: 8.0, top: 8.0),
                      child: new Text(
                        'Recepciones Pendientes',
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal
                        ),
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

Widget _pendingReception() {
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
              onPressed: (){}, 
              child: Text('Recepcionar')
            )
          ],
        )
      ],
    ),
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
