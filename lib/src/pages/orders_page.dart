import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrdersPage extends StatefulWidget{
  
  @override
  _OrdersPageState createState() => new _OrdersPageState();

}

class _OrdersPageState extends State<OrdersPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Pedidos",
            style: TextStyle(fontSize: 18)
          ),
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
                        Icon(Icons.developer_board,
                        size: 100,),
                        SizedBox(height: 5),
                        Text("Orden de Trabajo",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/orders_input");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 1.5,
                    color: Colors.grey.shade300,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.style_outlined,
                        size: 100,),
                        SizedBox(height: 5),
                        Text("Vale de Consumo",
                          style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => FunkyOverlay(),
    );
  }
  
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  final TextEditingController _otNumber = new TextEditingController();

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
      title: Text('Busqueda OT'),
      content:
        TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black, fontSize: 16.0),
          controller: _otNumber,
          decoration: const InputDecoration(
            hintText: 'Ejemplo: 0098988212',
            contentPadding: EdgeInsets.all(20.0),
            isDense: true,
          ),
          validator: (value){
            if(value.isEmpty){
              return 'OT Inválida';
            }
            return null;
          },
        ),          
      actions: <Widget>[
        FlatButton(
            child: Text("Aceptar"),
            textColor: Colors.blue,
            onPressed: () {/* 
               Fluttertoast.showToast(
                msg: "Módulo aún sin implementar",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
              );
              Navigator.of(context).pop(); */
              Navigator.pushNamed(context, '/orders_input_ot',arguments: _otNumber.text);
            }),

        FlatButton(
            child: Text("Cancelar"),
            textColor: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}