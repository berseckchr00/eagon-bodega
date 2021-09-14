import 'dart:convert';

import 'package:flutter/material.dart';

class OrderInputForm{

  List<Map<String, String>> _listBodega;

  String _fields = json.encode({
    'fields': [
      {'key': 'maquina', 'type': 'Input', 'label': 'Maquina', 'required': false,'hiddenLabel': true},
      {'key': 'centro_costo', 'type': 'Input', 'label': 'Centro de Costo', 'required': true,'hiddenLabel': true},
      {'key': 'item_gasto', 'type': 'Input', 'label': 'Numero Item Gasto', 'required': true,'hiddenLabel': true}
    ]
  });

  Map _decorations = {
    /* 'bodega':  InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      filled: true,
      fillColor: Colors.grey[200],
      hintText: 'Bodega', 
      errorText: 'Selecciona una Bodega',

    ), */
    'maquina': InputDecoration(
      labelText: "Maquina",
      prefixIcon: Icon(Icons.info_outline),
      border: OutlineInputBorder()
    ),
    'centro_costo': InputDecoration(
      labelText: "Centro de Costo",
      prefixIcon: Icon(Icons.info_outline),
      border: OutlineInputBorder()
    ),
    'item_gasto': InputDecoration(
      labelText: "Item de Gasto",
      prefixIcon: Icon(Icons.info_outline),
      border: OutlineInputBorder()
    )
  };

  String get fields => this._fields;

  Map get decorations => this._decorations;

  set listBodegas(List<Map<String, String>> map) => this._listBodega = map;
  
  List<Map<String, String>> get getlistBodegas => this._listBodega;
}