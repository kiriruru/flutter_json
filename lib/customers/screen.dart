import 'package:docxtpl/docxtpl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../app/DataSource.dart';
import '../app/TeamplateSource.dart';
import './cubit.dart';

class HomePage extends StatelessWidget {
  final dataSource = Modular.get<DataSource>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text("Json")),
        body: BlocProvider(
          create: (_) => ChosenUserCubit(dataSource),
          child: Row(
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

class UsersListWidget extends StatelessWidget {
  final dataSource = Modular.get<DataSource>();

  Future<void> generate(String tplPath) async {
    print("start generate");

    final DocxTpl docxTpl = DocxTpl(
      docxTemplate: tplPath,
    );

    var response = await docxTpl.parseDocxTpl();
    print(response.mergeStatus);
    print(response.message);

    var fields = docxTpl.getMergeFields();
    print('[INFO] local template file fields found: ');
    print(fields);

    var templateData = {
      'CLIENT_FIO_UC': 'Begov Alimardon',
      'CLIENT_PASSPORT': '9988 777666',
      'COMPANY_NAME': 'Vanguard',
      'COMPANY_PIB': '00010010110',
      'DD_MM_YYYY': '02.03.2023',
    };

    if (response.mergeStatus == MergeResponseStatus.Success) {
      await docxTpl.writeMergeFields(data: templateData);
      var savedFile = await docxTpl.save('generatedDocument.docx');
    }
  }

  Future<bool> getUsers() async {
    await dataSource.getInitData();
    TeamplateSource teamplates =
        PocketBaseTeamplateSource("http://127.0.0.1:8090");
    String tplPath = await teamplates.getDocumentPath("izjava");
    await generate(tplPath); // function from template2_docx.dart
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChosenUserCubit>(context);
    return FutureBuilder(
      future: getUsers(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: dataSource.usersList.length,
            itemBuilder: (context, index) {
              var item = dataSource.usersList[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(item.getStringValue("username")),
                subtitle: Text(item.getStringValue("email")),
                onTap: () => cubit.choseUser(item.id),
              );
            },
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

class ConfigInputsWidget extends StatelessWidget {
  final dataSource = Modular.get<DataSource>();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChosenUserCubit>(context);
    return BlocBuilder<ChosenUserCubit, ChosenUserCubitState>(
      builder: (context, state) {
        if (state is ChosenUserCubitStateInit) {
          return Center(
            child: Row(
              children: const [
                Icon(Icons.arrow_back),
                Text("Select user"),
              ],
            ),
          );
        } else if (state is ChosenUserCubitStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChosenUserCubitStateReady) {
          return SingleChildScrollView(
            child: Column(
                children: dataSource.config.values
                    .map((value) => InputWidget(
                          initValue: state.data[value["title"]] ?? "",
                          config: value,
                          onStopEditing: cubit.updateUserData,
                          id: state.id,
                        ))
                    .toList()),
          );
        } else if (state is ChosenUserCubitStateError) {
          return Container(child: Text(state.error));
        }
        return Container();
      },
    );
  }
}

class InputWidget extends StatelessWidget {
  final String initValue;
  final String id;
  final Map<String, String> config;
  final Function onStopEditing;
  final TextEditingController _controller = TextEditingController();

  InputWidget({
    super.key,
    required this.initValue,
    required this.config,
    required this.onStopEditing,
    required this.id,
  }) {
    _controller.text = initValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChosenUserCubit>(context);
    return Focus(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: config["title"],
            hintText: config["hint"],
          ),
          controller: _controller,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          onStopEditing(id, config["title"], _controller.text);
        });
  }
}
