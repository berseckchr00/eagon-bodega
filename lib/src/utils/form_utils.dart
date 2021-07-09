import 'package:flutter/material.dart';

 TextFormField createTextFormField(String label, String value, bool readOnly, {bool multiline = false}){
    return (multiline)? TextFormField(
        decoration: InputDecoration(labelText: label),
        readOnly: readOnly,
        initialValue: value,
      ):
      TextFormField(
        decoration: InputDecoration(labelText: label),
        readOnly: readOnly,
        initialValue: value,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      );
  }