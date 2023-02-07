import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final List<String> config = ["name", "surname", "age", "country", "city"];
  final File file = File('assets/example.json');
  // final Map<String, Map<String, String>> conf = {
  //   "name": {
  //     "title": "Name",
  //     "exampleOfFilling": "Ivan",
  //     "hint": "Fill the name from passport",
  //   },
  //   "surname": {
  //     "title": "Surname",
  //     "exampleOfFilling": "Ivanov",
  //     "hint": "Fill the surname from passport",
  //   },
  //   "age": {
  //     "title": "Age",
  //     "exampleOfFilling": "25",
  //     "hint": "Enter age from passport",
  //   },
  //   "country": {
  //     "title": "Country",
  //     "exampleOfFilling": "Montenegro",
  //     "hint": "Enter country of residence",
  //   },
  //   "city": {
  //     "title": "City",
  //     "exampleOfFilling": "Budva",
  //     "hint": "Enter city",
  //   },
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Json"),
      ),
      body: AllInputsWidget(
        file: file,
        config: config,
      ),
    );
  }
}

class AllInputsWidget extends StatefulWidget {
  final File file; // from parent widget
  final List<String> config; // from parent widget
  const AllInputsWidget({
    super.key,
    required this.file,
    required this.config,
  });

  @override
  State<AllInputsWidget> createState() => _AllInputsWidgetState();
}

class _AllInputsWidgetState extends State<AllInputsWidget> {
  Map<String, dynamic> _jsonItem = {};
  File file = File(""); // from parent widget
  List<String>? config; // from parent widget

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  Future<void> asyncMethod() async {
    file = widget.file;
    config = widget.config;
    await readJsonData();
  }

  Future<void> readJsonData() async {
    final String jsonData = await file.readAsString();
    final json = jsonDecode(jsonData);
    setState(() => _jsonItem = json);
    print("JSON from readJsonData $_jsonItem");
  }

  Future<void> onStopEditing(key, value) async {
    setState(() => _jsonItem[key] = value);
    final jsonDataUpdated = jsonEncode(_jsonItem);
    await file.writeAsString(jsonDataUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: config!
            .map((String e) => InputWidget(
                  fieldToFillAsKey: e,
                  item: _jsonItem,
                  onStopEditing: onStopEditing,
                ))
            .toList());
  }
}

class InputWidget extends StatefulWidget {
  Map<String, dynamic> item = {}; // from parent widget
  final String fieldToFillAsKey; // from parent widget
  final Function onStopEditing; // from parent widget

  InputWidget({
    super.key,
    required this.fieldToFillAsKey,
    required this.item,
    required this.onStopEditing,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  Map<String, dynamic> _item = {};
  String? _fieldToFill;
  TextEditingController _controller = TextEditingController();

  void updateInfo() {
    widget.onStopEditing(_fieldToFill, _controller.text ?? "");
  }

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _fieldToFill = widget.fieldToFillAsKey;
    _controller.text = widget.item[_fieldToFill] ?? "";
    // print(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        child: TextFormField(
          decoration: InputDecoration(hintText: _fieldToFill),
          controller: _controller,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          updateInfo();
        });
  }
}
