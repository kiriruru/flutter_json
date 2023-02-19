import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../classes/DataSource.dart';
import '../cubit/chosen_cubit.dart';

class UsersListWidget extends StatelessWidget {
  UsersListWidget({super.key});

  final dataSource = Modular.get<DataSource>();

  Future<bool> getUsers() async {
    await dataSource.getUsersData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChosenUserCubit>(context);
    return FutureBuilder(
      future: getUsers(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: dataSource.usersList
                  .map((e) => ListTile(
                        leading: Icon(Icons.person),
                        title: Text("${e.data["json"]["name"]}"),
                        subtitle: Text("${e.data["json"]["email"]}"),
                        onTap: () {
                          cubit.choseUser("");

                          cubit.choseUser(e.id);
                        },
                      ))
                  .toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("Something went wrong");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
