import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:meta/meta.dart';

class NotificationSetting{
  String title;
  String subtitle;
  String quantity;
  bool value;
  int indexItem;

  NotificationSetting({
    @required this.title,
    @required this.subtitle,
    @required this.quantity,
    @required this.indexItem,
    this.value = false
  });
}