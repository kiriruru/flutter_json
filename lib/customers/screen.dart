import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../classes/DataSource.dart';
import '../cubit/chosen_cubit.dart';
import './users_list.dart';
import './config_inputs.dart';

class HomePage extends StatelessWidget {
  final dataSource = Modular.get<DataSource>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => ChosenUserCubit(dataSource),
        child: Scaffold(
          appBar: AppBar(title: const Text("Json")),
          body: Row(
            children: <Widget>[
              Expanded(child: UsersListWidget()),
              Container(width: 2, color: Colors.black),
              Expanded(child: ConfigInputsWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
