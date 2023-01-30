import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json/models/person.dart';

void main(List<String> arg) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Json fles"),
        ),
        body: FutureBuilder(
          future: readJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Text("${data.error}");
            } else if (data.hasData) {
              var people = data.data as List<Person>;
              return ListView.builder(
                  itemCount: people == null ? 0 : people.length,
                  itemBuilder: (context, index) {
                    return Text(people[index].name.toString());
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Person>> readJsonData() async {
    final jsonData = await rootBundle.loadString('jsonfile/example.json');
    final list = json.decode(jsonData) as List<dynamic>;
    return list.map((e) => Person.fromJson(e)).toList();
  }
}
