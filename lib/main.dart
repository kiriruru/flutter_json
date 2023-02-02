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
  // variables

  List<Person> _items = [];
  final File file = File('assets/example.json');
  bool isActiveButton = false;

  final _formKey = GlobalKey<FormState>();
  Person personOnCreate = Person();
  // TextEditingController _controllerName = TextEditingController();
  // TextEditingController _controllerSurname = TextEditingController();
  // TextEditingController _controllerAge = TextEditingController();

  String initialJsonData =
      '[{"name":"Ali","surname":"Begov","age":25},{"name":"Alimardon","surname":"b","age":6},{"name":"Ekarfe","surname":"Duno","age":4}]';
  Person personOne = Person(name: "Anton", surname: "Krasnih", age: 31);

// CRUD

// Future<void> readJsonData() async {
  //   final String jsonData = await file.readAsString();
  //   final json = jsonDecode(jsonData) as List<dynamic>;
  //   final people =
  //       json.map((e) => Person.fromJson(e as Map<String, dynamic>)).toList();
  //   setState(() => _items = people);
  // }

  Future<void> addJsonData(Person newPerson) async {
    setState(() => _items.add(newPerson));
    final jsonDataUpdated = jsonEncode(_items);
    await file.writeAsString(jsonDataUpdated);
  }

  Future<void> removeLastJsonData() async {
    if (_items.isNotEmpty) {
      setState(() => {_items.removeLast()});
      final jsonDataUpdated = jsonEncode(_items);
      await file.writeAsString(jsonDataUpdated);
    }
  }

  Future<void> resetJsonData() async {
    final json = jsonDecode(initialJsonData) as List<dynamic>;
    final people = json
        .map((dynamic e) => Person.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() => _items = people);
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
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    // controller: _controllerName,
                    // onChanged: (value) {
                    //   value.isNotEmpty
                    //       ? setState(() => isActiveButton = true)
                    //       : null;
                    // },
                    onChanged: (value) => value.isNotEmpty
                        ? setState(() => isActiveButton = true)
                        : setState(() => isActiveButton = false),
                    onSaved: ((value) =>
                        setState(() => personOnCreate.name = value)),
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    onChanged: (value) => value.isNotEmpty
                        ? setState(() => isActiveButton = true)
                        : setState(() => isActiveButton = false),
                    onSaved: ((value) =>
                        setState(() => personOnCreate.surname = value)),
                    decoration: const InputDecoration(labelText: 'Surname'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value == null ||
                          value.isEmpty && personOnCreate.name != "") {
                        setState(() => personOnCreate.age = null);
                      } else if (personOnCreate.name != "" ||
                          personOnCreate.surname != "") {
                        personOnCreate.age = int.tryParse(value ?? '') ?? null;
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Age'),
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      if (isActiveButton == true)
                        {
                          _formKey.currentState?.save(),
                          addJsonData(personOnCreate),
                          personOnCreate = Person(),
                        },
                      if (isActiveButton == false) null
                    },
                    child: Text("Add person"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => addJsonData(personOne),
              child: Text("Add the single person"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => removeLastJsonData(),
              child: Text("Remove last person"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => resetJsonData(),
              child: Text("Reset data"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        child: Text("${_items[index].name}"),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text("${_items[index].surname}"),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text("${_items[index].age}"),
                      ),
                    ],
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

// validator: (value) {
//   if (value == null || value.isEmpty) {
//     return 'Please enter a number';
//   }
//   if (double.tryParse(value) == null) {
//     return 'Please enter a valid number';
//   }
//   return null;
// },
