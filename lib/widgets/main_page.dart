import 'package:flutter/material.dart';
import 'package:flutter_js/interface.dart';

class MainPage extends StatelessWidget {
  DataSource dataSource;
  MainPage({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Json")),
      body: AllInputsWidget(dataSource: dataSource),
    );
  }
}

class AllInputsWidget extends StatefulWidget {
  final DataSource dataSource;
  const AllInputsWidget({super.key, required this.dataSource});

  @override
  State<AllInputsWidget> createState() => _AllInputsWidgetState();
}

class _AllInputsWidgetState extends State<AllInputsWidget> {
  Future<bool> readJsonData() async {
    await widget.dataSource.readData();
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
                children: widget.dataSource.config.values
                    .map((value) => InputWidget(
                          initValue:
                              widget.dataSource.jsonItem[value["title"]] ?? "",
                          config: value,
                          onStopEditing: widget.dataSource.updateData,
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

class InputWidget extends StatefulWidget {
  final String initValue; // from parent widget
  final Map<String, String> config; // from parent widget
  final Function onStopEditing; // from parent widget

  const InputWidget({
    super.key,
    required this.initValue,
    required this.config,
    required this.onStopEditing,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.initValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: widget.config["title"],
            hintText: widget.config["hint"],
          ),
          controller: _controller,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          widget.onStopEditing(widget.config["title"], _controller.text);
        });
  }
}
