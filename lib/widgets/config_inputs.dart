import 'package:flutter/material.dart';
import '../classes/DataSource.dart';

class ConfigInputsWidget extends StatelessWidget {
  final DataSource dataSource;
  const ConfigInputsWidget({super.key, required this.dataSource});

  Future<bool> readJsonData() async {
    await dataSource.readData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readJsonData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
                children: dataSource.config.values
                    .map((value) => InputWidget(
                          initValue: dataSource.jsonItem[value["title"]] ?? "",
                          config: value,
                          onStopEditing: dataSource.updateData,
                        ))
                    .toList()),
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

class InputWidget extends StatelessWidget {
  final String initValue; // from parent widget
  final Map<String, String> config; // from parent widget
  final Function onStopEditing; // from parent widget
  final TextEditingController _controller = TextEditingController();

  InputWidget({
    super.key,
    required this.initValue,
    required this.config,
    required this.onStopEditing,
  }) {
    _controller.text = initValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
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
          onStopEditing(config["title"], _controller.text);
        });
  }
}
