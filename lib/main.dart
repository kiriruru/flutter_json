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
  List _items = [];
  Person personOne = Person(name: "Anton", surname: "Krasnih", age: 31);

  Future<void> readJsonData() async {
    final jsonData = await rootBundle.loadString('assets/example.json');
    final list = jsonDecode(jsonData);

    list
        .map((dynamic e) => Person.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _items = list;
    });
  }

  Future<void> addJsonData(newPerson) async {
    final person = newPerson.toJson();

    setState(() {
      _items.add(person);
    });
    final File file = File('assets/example.json');

    //! first example
    // final jsonDataUpdated = jsonEncode(_items); // !правильный формат, почему-то не хочет дальше перезаписывать
    // await file.writeAsString(jsonDataUpdated);

    //! second example

    String content = await file.readAsString();
    List myList = jsonDecode(content);
    myList.add(person);
    await file.writeAsString(jsonEncode(myList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Json"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_items',
            ),
            SizedBox(height: 40),
            ElevatedButton(
                onPressed: () => readJsonData(),
                child: Icon(Icons.data_saver_off_rounded)),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => addJsonData(personOne), child: Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}
