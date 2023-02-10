import 'package:flutter/material.dart';
import 'package:flutter_js/interface.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Json")),
      body: const AllInputsWidget(
          source: "local",
          dataPath: "assets/example.json",
          configPath: "assets/config.json"),
    );
  }
}

class AllInputsWidget extends StatefulWidget {
  final String source;
  final String dataPath;
  final String configPath;

  const AllInputsWidget({
    super.key,
    required this.source,
    required this.dataPath,
    required this.configPath,
  });

  @override
  State<AllInputsWidget> createState() => _AllInputsWidgetState();
}

class _AllInputsWidgetState extends State<AllInputsWidget> {
  late DataSource exampleOfData;
  Map<String, dynamic> _jsonItem = {};
  Map<String, Map<String, String>> _config = {};

  @override
  void initState() {
    if (widget.source == "local") {
      exampleOfData = LocalDataSource(widget.dataPath, widget.configPath);
    } else if (widget.source == "http") {
      exampleOfData = HttpDataSource(widget.dataPath, widget.configPath);
    }
  }

  Future<bool> readJsonData() async {
    _jsonItem = await exampleOfData.readData();
    _config = await exampleOfData.readConfig();
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
                children: _config.values
                    .map((value) => InputWidget(
                          initValue: _jsonItem[value["title"]] ?? "",
                          config: value,
                          onStopEditing: exampleOfData.updateData,
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
            // helperText: widget.config["exampleOfFilling"]
          ),
          controller: _controller,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          widget.onStopEditing(widget.config["title"], _controller.text);
        });
  }
}
