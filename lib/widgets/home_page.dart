import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chosen_cubit.dart';
import './users_list.dart';
import './config_inputs.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => ChosenUserCubit(""),
        child: Scaffold(
          appBar: AppBar(title: const Text("Json")),
          body: Container(
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(child: UsersListWidget()),
                Container(width: 2, color: Colors.black),
                Expanded(child: ConfigInputsWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
