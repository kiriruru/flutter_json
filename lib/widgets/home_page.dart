import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './users_list.dart';
import './config_inputs.dart';
import '../classes/DataSource.dart';

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
              Expanded(child: UsersListWidget()),
              if (userChosen == false)
                Text("Select user")
              else
                Expanded(child: ConfigInputsWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
