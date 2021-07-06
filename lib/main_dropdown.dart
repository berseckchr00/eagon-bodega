import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class User {
  const User(this.name);    
  final String name;
}

class MyApp extends StatefulWidget {
  State createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  User selectedUser;
  List<User> users = <User>[User('Foo'), User('Bar')];    
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: new DropdownButton<User>(
            hint: new Text("Select a user"),
            value: selectedUser,
            onChanged: (User newValue) {
              setState(() {
                selectedUser = newValue;
              });
            },
            items: users.map((User user) {
              return new DropdownMenuItem<User>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}