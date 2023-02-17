import 'package:flutter/material.dart';
import './users_list.dart';
import './config_inputs.dart';

class HomePage extends StatelessWidget {
  bool userChosen = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Json")),
        body: Container(
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(child: UsersListWidget(userChosen)),
              Container(width: 2, color: Colors.black),
              Expanded(child: ConfigInputsWidget(userChosen)),
            ],
          ),
        ),
      ),
    );
  }
}
