import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/Person.dart';

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
  String initialJsonData =
      '[{"name":"Ali","surname":"Begov","age":25},{"name":"Alimardon","surname":"b","age":6},{"name":"Ekarfe","surname":"Duno","age":4}]';

  List _items = [];
  final File file = File('assets/example.json');

  Person personOne = Person(name: "Anton", surname: "Krasnih", age: 31);

  Future<void> resetJsonData() async {
    final list = jsonDecode(initialJsonData);
    list
        .map((dynamic e) => Person.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() => _items = list);
    final jsonDataUpdated = jsonEncode(_items);
    await file.writeAsString(jsonDataUpdated);
  }

  Future<void> readJsonData() async {
    final String jsonData = await file.readAsString();
    final list = jsonDecode(jsonData);
    list
        .map((dynamic e) => Person.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() => _items = list);
  }

  Future<void> addJsonData(Person newPerson) async {
    final person = newPerson.toJson();
    setState(() => _items.add(person));

    final jsonDataUpdated = jsonEncode(_items);
    await file.writeAsString(jsonDataUpdated);
  }

  Future<void> removeLastJsonData() async {
    setState(() => {if (_items.length > 0) _items.removeLast()});

    final jsonDataUpdated = jsonEncode(_items);
    await file.writeAsString(jsonDataUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Json"),
        ),
        body: Column(
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) => value == null ? 'Name is required' : null,
              ),
            ),
            Form(
              child: TextFormField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  labelText: 'Surname',
                ),
                validator: (value) =>
                    value == null ? 'Surname is required' : null,
              ),
            ),
            Form(
              child: TextFormField(
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) => value == null ? 'Age is required' : null,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("List of people"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

// body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'People list:',
//             ),
//             Text(
//               '$_items',
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () => resetJsonData(),
//               child: Text("Reset data"),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => readJsonData(),
//               child: Text("Load data"),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => addJsonData(personOne),
//               child: Text("Add person"),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => removeLastJsonData(),
//               child: Text("Remove last person"),
//             )
//           ],
//         ),
//       ),
