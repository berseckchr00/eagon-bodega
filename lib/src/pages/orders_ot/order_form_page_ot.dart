
import 'package:eagon_bodega/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnDelete();

class OrderFormOt extends StatefulWidget {

  final ProductModel product ;
  final state = _OrderFormOtState();
  final OnDelete onDelete;
  final index;

  OrderFormOt({Key key, this.product, this.index, this.onDelete}) : super(key: key);
  @override
  _OrderFormOtState createState() => state;

  bool isValid() => state.validate();
}

class _OrderFormOtState extends State<OrderFormOt> {
  final form = GlobalKey<FormState>();
  TextEditingController cantidadEditor ;
  TextEditingController unidadMedidaEditor;

  @override
  Widget build(BuildContext context) {
    cantidadEditor = new TextEditingController(text: widget.product.cantidad);
    unidadMedidaEditor = new TextEditingController(text: widget.product.unidadMedida);
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 0, left: 10, right: 10),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                leading: Padding(
                  padding: EdgeInsets.all(5),
                  child:
                   Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey,
                      child: Center(
                        child: 
                          Text(widget.index.toString(),
                          style: TextStyle(
                            fontSize: 20
                          ),
                        )),
                    ),
                  ),
                //elevation: 0,
                title: Text(widget.product.glosa),
                backgroundColor: Theme.of(context).accentColor,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child:Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, top: 8),
                      child: TextFormField(
                        initialValue: widget.product.producto,
                        onSaved: (val) => widget.product.producto = val,
                        validator: (val) =>
                            val.length > 3 ? null : 'Código Inválido',
                        decoration: InputDecoration(
                          labelText: 'Código Producto',
                          hintText: 'Ingresa el código del producto',
                          icon: Icon(Icons.production_quantity_limits),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: 
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 8),
                        child: 
                        TextFormField(
                          initialValue: widget.product.nombre,
                          onSaved: (val) => widget.product.idUbicacion = val,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow((RegExp("[.0-9]"))) ,
                          ],
                          validator: (val) =>
                              int.parse(val) < 1 ? null : 'Ubicación',
                          decoration: InputDecoration(
                            labelText: 'Ubicación',
                            hintText: 'Ingresa una ubicación',
                            icon: Icon(Icons.production_quantity_limits),
                            isDense: true,
                          ),
                        ),
                      ),
                    )
                ]),
              Row(
                children: [
                  Expanded(
                    child:
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 16),
                        child: 
                        TextFormField(
                          //initialValue: widget.product.cantidad,
                          controller:  cantidadEditor,
                          onSaved: (val) => cantidadEditor.text = val,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow((RegExp("[.0-9]"))) ,
                          ],
                          validator: (val) =>
                              int.parse(val) < 1 ? null : 'Cantidad Inválida',
                          decoration: InputDecoration(
                            labelText: 'Cantidad',
                            hintText: 'Ingresa cantidad',
                            icon: Icon(Icons.production_quantity_limits),
                            isDense: true,
                          ),
                        ),
                      ),
                  ),
                  Expanded(
                    child: 
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 16),
                        child: 
                        TextFormField(
                          //initialValue: widget.product.unidadMedida,
                          controller: unidadMedidaEditor,
                          onSaved: (val) => unidadMedidaEditor.text = val,
                          /* inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow((RegExp("[.0-9]"))) ,
                          ], */
                          validator: (val) =>
                              int.parse(val) < 1 ? null : 'Unidad Medida Inválida',
                          decoration: InputDecoration(
                            labelText: 'Unidad Medida',
                            hintText: 'Ingresa unidad de medida',
                            icon: Icon(Icons.production_quantity_limits),
                            isDense: true,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
        ),
      );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }
}