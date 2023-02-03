import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final File file = File('assets/example.json');
  final List<String> config = ["name", "surname", "age", "country", "city"];

  Map<String, dynamic> _jsonItem = {};

  bool isActiveButton = false;

  Future<void> onStopEditing(key, value) async {
    setState(() => _jsonItem[key] = value);
    final jsonDataUpdated = jsonEncode(_jsonItem);
    await file.writeAsString(jsonDataUpdated);
  }

  void readJsonData() async {
    final File file = File('assets/example.json');
    final String jsonData = await file.readAsString();
    final json = jsonDecode(jsonData);
    setState(() => _jsonItem = json);
  }

  @override
  Widget build(BuildContext context) {
    readJsonData();
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
                        onStopEditing: onStopEditing,
                        textAsValue: _jsonItem[e] ?? '',
                      ))
                  .toList()),
          Expanded(
            child: ListView.builder(
              itemCount: _jsonItem.length,
              itemBuilder: (context, index) {
                final key = _jsonItem.keys.elementAt(index);
                final value = _jsonItem[key];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: Text("$key"),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text("$value"),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InputWidget extends StatefulWidget {
  final String fieldToFillAsKey;
  final String textAsValue;
  final Function onStopEditing;

  InputWidget(
      {super.key,
      required this.fieldToFillAsKey,
      required this.onStopEditing,
      required this.textAsValue});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController controller = TextEditingController();
  String? fieldToFill;

  void updateInfo() {
    widget.onStopEditing(fieldToFill, controller.text);
  }

  void initState() {
    fieldToFill = widget.fieldToFillAsKey;
    controller.text = widget.textAsValue;
  }

  @override
  Widget build(BuildContext context) {
    print(controller.text);
    return Focus(
        child: TextFormField(
          decoration: InputDecoration(hintText: fieldToFill),
          controller: controller,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          updateInfo();
        });
  }
}
