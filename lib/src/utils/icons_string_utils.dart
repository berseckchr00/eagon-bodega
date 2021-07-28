import 'package:flutter/material.dart';

final _icon = <String, IconData>{
  'home_rounded'  : Icons.home_rounded,
  'exit_to_app'   : Icons.exit_to_app,
  'add_alert'     : Icons.add_alert,
  'accessibility' : Icons.accessibility,
  'assignment_returned_outlined' : Icons.assignment_returned_outlined,
};

Icon getIconByString(String iconName){
  return Icon( _icon[iconName], color: Colors.orange);
  
}