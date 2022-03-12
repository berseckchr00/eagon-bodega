
import 'package:flutter/material.dart';

class PurchaseOrderClass {
  final String productCode;
  final String productGlosa;

  PurchaseOrderClass({
    this.productCode,
    this.productGlosa,
  });
}

class DropdownUtils extends StatelessWidget {
  
  final List<DropdownMenuItem<PurchaseOrderClass>> dropdownMenuItemList;
  final ValueChanged<PurchaseOrderClass> onChanged;
  final PurchaseOrderClass value;
  final bool isEnabled;

  DropdownUtils({
    Key key,
    @required this.dropdownMenuItemList,
    @required this.onChanged,
    @required this.value,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            color: isEnabled ? Colors.white : Colors.grey.withAlpha(100)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            itemHeight: 50.0,
            style: TextStyle(
                fontSize: 15.0,
                color: isEnabled ? Colors.black : Colors.grey[700]),
            items: dropdownMenuItemList,
            onChanged: onChanged,
            value: value,
          ),
        ),
      ),
    );
  }
}