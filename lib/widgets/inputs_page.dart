import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class InputsPage extends StatelessWidget {
  InputsPage({super.key});
  final File file = File('assets/example.json');
  final List<String> config = ["name", "surname", "age", "country", "city"];
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
      body: Column(
        children: <Widget>[
          Column(
              children: config
                  .map((String e) => InputWidget(
                        fieldToFillAsKey: e,
                        document: file,
                      ))
                  .toList()),
        ],
      ),
    );
  }
}

class InputWidget extends StatefulWidget {
  final String fieldToFillAsKey;
  final File document;

  const InputWidget({
    super.key,
    required this.fieldToFillAsKey,
    required this.document,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  File file = File("");
  Map<String, dynamic> _jsonItem = {};
  String? _fieldToFill;
  TextEditingController _controller = TextEditingController();

  Future<void> readJsonData() async {
    print(file);
    final String jsonData = await file.readAsString();
    final json = jsonDecode(jsonData);
    setState(() => _jsonItem = json);
  }

  Future<void> onStopEditing(key, value) async {
    setState(() => _jsonItem[key] = value);
    final jsonDataUpdated = jsonEncode(_jsonItem);
    await file.writeAsString(jsonDataUpdated);
  }

  void initState() {
    super.initState();
    asyncMethod();
  }

  Future<void> asyncMethod() async {
    setState(() {
      file = widget.document;
    });
    await readJsonData();
    setState(() {
      _fieldToFill = widget.fieldToFillAsKey;
      _controller.text = _jsonItem[_fieldToFill] ?? "";
    });
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
          onStopEditing(_fieldToFill, _controller.text ?? "");
        });
  }
}
