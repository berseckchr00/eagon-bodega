import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';

import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/models/reception_response.dart';
import 'package:eagon_bodega/src/pages/receptions/reception_list_page.dart';
import 'package:eagon_bodega/src/providers/reception_provider.dart';
import 'package:eagon_bodega/src/setting/notification_setting.dart';

import 'package:flutter/material.dart';

class ReceptionQuantity extends StatefulWidget {
  @override
  _ReceptionQuantityState createState() => _ReceptionQuantityState();
}

class _ReceptionQuantityState extends State<ReceptionQuantity> {
  List<Detail> items;

  final allowNotifications = NotificationSetting(title: 'Allow Notifications');

  final notifications = [
    NotificationSetting(title: 'Show Message'),
  ];

  List<Detail> listDetailOc = [];
  bool submitting = false;

  Widget buidlToggleCheckBox(NotificationSetting notification) => buildCheckBox(
      notification: notification,
      onClicked: () {
        final newValue = !notification.value;

        setState(() {
          allowNotifications.value = newValue;
          notifications.forEach((element) {
            element.value = newValue;
          });
        });
      });

  void _toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalle"),
        ),
        body: Column(children: [
          Expanded(
            child: ListView(
              children: [
                Divider(),
                ...notifications.map(buildSingleCheckBox).toList(),
              ],
            ),
          ),
          Container(
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 20),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                      onPressed: () {
                        _submitData();
                      },
                      child: Text(
                        'Ingresar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ))))
        ]));
  }

  Widget buildCheckBox({
    @required NotificationSetting notification,
    @required VoidCallback onClicked,
  }) =>
      Padding(
          padding: EdgeInsets.all(3.0),
          child: ListTile(
            onTap: onClicked,
            trailing: Checkbox(
              value: notification.value,
              onChanged: (value) => onClicked(),
            ),
            title: Text(
              notification.title,
              style: TextStyle(fontSize: 16),
            ),
            subtitle: _row(notification),
            leading: Icon(Icons.arrow_right_sharp),
            tileColor: _checkColor(notification.value),
          ));

  Widget buildSingleCheckBox(NotificationSetting notification) => buildCheckBox(
      notification: notification,
      onClicked: () {
        setState(() {
          final newValue = !notification.value;
          notification.value = newValue;

          if (!newValue) {
            allowNotifications.value = false;
          } else {
            final allow = notifications.every((element) => notification.value);
            allowNotifications.value = allow;
          }
        });
      });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(this.context).settings.arguments as ReceptionArguments;
    listDetailOc = _castClassPurchase(jsonDecode(args.detailPurchase));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* final args = ModalRoute.of(this.context).settings.arguments as ReceptionArguments;
    _castClassPurchase(jsonDecode(args.detailPurchase)); */
  }

  List<Detail> _castClassPurchase(List<dynamic> obj) {
    List<Detail> lstDetail = [];
    notifications.removeWhere((element) => element.quantity == null);
    int indexVal = 0;

    obj.forEach((element) {
      String json = jsonEncode(element);
      Detail d = Detail.fromJson(jsonDecode(json));
      notifications.add(new NotificationSetting(
          title: d.glosa,
          subtitle: 'Cantidad',
          quantity: d.cantidad,
          indexItem: indexVal));
      lstDetail.add(d);
      indexVal++;
    });

    return lstDetail;
  }

  _checkColor(bool value) {
    return (value) ? Colors.green.shade200 : Colors.red.shade200;
  }

  _row(NotificationSetting element) {
    return Row(
      children: [
        Text('Cantidad:'),
        SizedBox(width: 30),
        Expanded(
          child: TextFormField(
            initialValue: (element != null)
                ? double.parse(element.quantity).toString()
                : 0.toString(),
            onChanged: (value) {
              listDetailOc[element.indexItem].cantidad = value;
            },
          ),
        ),
      ],
    );
  }

  Future _submitData() async {
    ReceptionProvider reception = new ReceptionProvider();
    String data = jsonEncode(listDetailOc);
    final Future<ReceptionResponse> respJson = reception.saveReception(data);

    _toggleSubmitState();
    respJson.then((value) => {
          _toggleSubmitState(),
          if (value != null)
            {
              if (value.success == 1)
                {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: 'Transacción Exitosa',
                    //autoCloseDuration: Duration(seconds: 4),
                    onConfirmBtnTap: () async {
                      Navigator.pushNamed(context, '/home');
                    },
                  )
                }
              else
                {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.confirm,
                    text: 'Se generó un error, ¿desea reintentar?',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: Colors.green,
                  )
                }
            }
        });
  }
}
