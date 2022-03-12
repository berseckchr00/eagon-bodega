

import 'package:eagon_bodega/src/utils/dropdown_utils.dart';
import 'package:flutter/material.dart';

class DropDownPurchaseOrderProvider{

  List<PurchaseOrderClass> _purchaseModelList = [];

  PurchaseOrderClass _purchaseModel = PurchaseOrderClass();

  List<DropdownMenuItem<PurchaseOrderClass>> _purchaseModelDropdownList;

  List<DropdownMenuItem<PurchaseOrderClass>> buildPurchaseModelDropdown(
      List purchaseModelList) {
    List<DropdownMenuItem<PurchaseOrderClass>> items = List();
    for (PurchaseOrderClass purchaseModel in _purchaseModelList) {
      items.add(DropdownMenuItem(
        value: purchaseModel,
        child: Text(purchaseModel.productGlosa),
      ));
    }
    return items;
  }

  
  setPurchaseModelList(List<PurchaseOrderClass> it){
    this._purchaseModelList = it;
  }

  getPurchaseModelList(){
    return this._purchaseModelList;
  }

  setPurchaseModel(PurchaseOrderClass it){
    this._purchaseModel = it;
  }

  getPurchaseModel(){
    return this._purchaseModel;
  }

  setPurchaseModelDropdownList(List<DropdownMenuItem<PurchaseOrderClass>> it){
    this._purchaseModelDropdownList = it;
  }

  getPurchaseModelDropdownList(){
    return this._purchaseModelDropdownList;
  }
  /*_onChangeFavouriteFoodModelDropdown(PurchaseOrderClass favouriteFoodModel) {
    setState(() {
      _favouriteFoodModel = favouriteFoodModel;
    });
  }*/
}