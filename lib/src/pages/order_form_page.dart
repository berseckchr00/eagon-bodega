
import 'package:eagon_bodega/src/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnDelete();

class OrderForm extends StatefulWidget {

  final Detalle detalle ;/*= Detalle.fromJson(jsonDecode("{\"detalle\":[{\"codigo_producto\":\"LM001\",\"nombre_producto\":\"List\u00f3n mediano 2' 5\/4\",\"cantidad\":\"10\",\"unidad_medida\":\"UN\"},{\"codigo_producto\":\"M09AG\",\"nombre_producto\":\"Lubricante tuercas M09AG\",\"cantidad\":\"250\",\"unidad_medida\":\"CC\"},{\"codigo_producto\":\"TC09502\",\"nombre_producto\":\"Tuerca conica 2' 5\/4\",\"cantidad\":\"500\",\"unidad_medida\":\"UN\"}]}"));*/
  final state = _OrderFormState();
  final OnDelete onDelete;
  final index;

  OrderForm({Key key, this.detalle, this.index, this.onDelete}) : super(key: key);
  @override
  _OrderFormState createState() => state;

  bool isValid() => state.validate();
}

class _OrderFormState extends State<OrderForm> {
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                leading: Icon(Icons.arrow_forward_outlined),
                //elevation: 0,
                title: Text(widget.detalle.nombreProducto),
                backgroundColor: Theme.of(context).accentColor,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, top: 8),
                child: TextFormField(
                  initialValue: widget.detalle.codigoProducto,
                  onSaved: (val) => widget.detalle.codigoProducto = val,
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
              Row(
                children: [
                  Expanded(
                    child:
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 16),
                        child: 
                        TextFormField(
                          initialValue: widget.detalle.cantidad,
                          onSaved: (val) => widget.detalle.cantidad = val,
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
                          initialValue: widget.detalle.unidadMedida,
                          onSaved: (val) => widget.detalle.unidadMedida = val,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow((RegExp("[.0-9]"))) ,
                          ],
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