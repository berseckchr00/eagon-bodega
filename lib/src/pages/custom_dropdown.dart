import 'package:flutter/material.dart';

class FavouriteFoodModel {
  final String foodName;
  final double calories;
  FavouriteFoodModel({
    this.foodName,
    this.calories,
  });
}

class CustomDropdown extends StatelessWidget {
  
  final List<DropdownMenuItem<FavouriteFoodModel>> dropdownMenuItemList;
  final ValueChanged<FavouriteFoodModel> onChanged;
  final FavouriteFoodModel value;
  final bool isEnabled;

  CustomDropdown({
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