

import 'package:flutter/material.dart';

import 'custom_dropdown.dart';

class HomeDrop extends StatefulWidget {
  HomeDrop({Key key}) : super(key: key);

  @override
  _HomeDropState createState() => _HomeDropState();
}

class _HomeDropState extends State<HomeDrop> {
  final List<FavouriteFoodModel> _favouriteFoodModelList = [
    FavouriteFoodModel(foodName: 'Pudding', calories: 161),
    FavouriteFoodModel(foodName: 'Frozen Yogurt', calories: 220),
    FavouriteFoodModel(foodName: 'Chocolate Milk', calories: 208),
  ];
  
  FavouriteFoodModel _favouriteFoodModel = FavouriteFoodModel();
  List<DropdownMenuItem<FavouriteFoodModel>> _favouriteFoodModelDropdownList;
  
  List<DropdownMenuItem<FavouriteFoodModel>> _buildFavouriteFoodModelDropdown(
      List favouriteFoodModelList) {
    List<DropdownMenuItem<FavouriteFoodModel>> items = List();
    for (FavouriteFoodModel favouriteFoodModel in favouriteFoodModelList) {
      items.add(DropdownMenuItem(
        value: favouriteFoodModel,
        child: Text(favouriteFoodModel.foodName),
      ));
    }
    return items;
  }

  _onChangeFavouriteFoodModelDropdown(FavouriteFoodModel favouriteFoodModel) {
    setState(() {
      _favouriteFoodModel = favouriteFoodModel;
    });
  }

  @override
  void initState() {
    _favouriteFoodModelDropdownList =
        _buildFavouriteFoodModelDropdown(_favouriteFoodModelList);
    _favouriteFoodModel = _favouriteFoodModelList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Custom Dropdown'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: const SizedBox(
                width: double.infinity,
                child: Text('Favourite food:'),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: CustomDropdown(
                dropdownMenuItemList: _favouriteFoodModelDropdownList,
                onChanged: _onChangeFavouriteFoodModelDropdown,
                value: _favouriteFoodModel,
                isEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}