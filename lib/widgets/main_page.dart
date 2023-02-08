import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final File file = File('assets/example.json');
  final File configFile = File('assets/config.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Json")),
      body: AllInputsWidget(file: file, configFile: configFile),
    );
  }
}

class AllInputsWidget extends StatefulWidget {
  final File file; // from parent widget
  final File configFile; // from parent widget

  const AllInputsWidget({
    super.key,
    required this.file,
    required this.configFile,
  });

  @override
  State<AllInputsWidget> createState() => _AllInputsWidgetState();
}

class _AllInputsWidgetState extends State<AllInputsWidget> {
  Map<String, dynamic> _jsonItem = {};

  @override
  void initState() {
    super.initState();
    readJsonData();
  }

  Future<Map<String, Map<String, String>>> readJsonConfig() async {
    final String jsonData = await widget.configFile.readAsString();
    final Map<String, dynamic> jsonParsed = jsonDecode(jsonData);

    final Map<String, Map<String, String>> finalMapFromJson = {};
    jsonParsed.forEach((key, value) {
      finalMapFromJson[key] = value.cast<String, String>();
    }); //
    return finalMapFromJson;
  }

  Future<void> readJsonData() async {
    final String jsonData = await widget.file.readAsString();
    final json = jsonDecode(jsonData);
    setState(() => _jsonItem = json);
  }

  Future<void> onStopEditing(key, value) async {
    if (_jsonItem[key] != value) {
      setState(() => _jsonItem[key] = value);
      final jsonDataUpdated = jsonEncode(_jsonItem);
      await widget.file.writeAsString(jsonDataUpdated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readJsonConfig(),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Map<String, String>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
              children: snapshot.data!.values
                  .map((value) => InputWidget(
                        initValue: _jsonItem[value["title"]] ?? "",
                        config: value,
                        onStopEditing: onStopEditing,
                      ))
                  .toList());
        }
        if (snapshot.hasError) {
          return Text("Something went wrong");
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
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
          widget.onStopEditing(
            widget.config["title"],
            _controller.text,
          );
        });
  }
}
