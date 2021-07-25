import 'dart:convert';

import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:eagon_bodega/src/pages/reception_list_page.dart';
import 'package:eagon_bodega/src/setting/notification_setting.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
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
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* final args = ModalRoute.of(this.context).settings.arguments as ReceptionArguments;
    _castClassPurchase(jsonDecode(args.detailPurchase)); */
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(this.context).settings.arguments as ReceptionArguments;
    _castClassPurchase(jsonDecode(args.detailPurchase));
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("detalle"),
      ),
      body: ListView(
          //children: _itemsForm(items)
          children: [
            //buidlToggleCheckBox(allowNotifications),
            Divider(),
            ...notifications.map(buildSingleCheckBox).toList(),
          ],
        )
    );
  }

  void _castClassPurchase(List<dynamic> obj){

    notifications.removeWhere((element) => element.quantity == null);
    obj.forEach((element) {
      String json = jsonEncode(element);
      Detail d = Detail.fromJson(jsonDecode(json));
      notifications.add(
        new NotificationSetting(title: d.glosa, subtitle: 'Cantidad', quantity: d.cantidad)
      );
    });
  }

  Widget buidlToggleCheckBox(NotificationSetting notification) => buildCheckBox(
    notification: notification, 
    onClicked: (){
      final newValue = !notification.value;

      setState(() {
        allowNotifications.value = newValue;
        notifications.forEach((element) {
          element.value = newValue;
        });
      });
    });

  Widget buildCheckBox({
    @required NotificationSetting notification,
    @required VoidCallback onClicked,
  })=> 
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
      )    
    );
    

  Widget buildSingleCheckBox(NotificationSetting notification) => buildCheckBox(
  notification: notification, 
  onClicked: (){
    setState(() {
      final newValue = !notification.value;
      notification.value = newValue;

      if(!newValue){
        allowNotifications.value = false;
      } else {
        final allow = 
          notifications.every((element) => notification.value);
        allowNotifications.value = allow;
      }

    });
  });

  _row(NotificationSetting element) {
      return Row(
        children: [
          Text('Cantidad:'),
          SizedBox(width: 30),
          Expanded(
            child: TextFormField(
              initialValue: (element != null)?element.quantity:0.toString(),
            ),
          ),
        ],
    );
  }

  _checkColor(bool value) {
    return (value)?Colors.green.shade200:Colors.red.shade200;
  }
}