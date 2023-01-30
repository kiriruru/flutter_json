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
                    return Center(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('name: ${people[index].name.toString()}'),
                              SizedBox(width: 50),
                              Text(
                                  'surname: ${people[index].surname.toString()}'),
                              SizedBox(width: 50),
                              Text('age: ${people[index].age.toString()}'),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return const Center(
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
    final list = jsonDecode(jsonData) as List<dynamic>;
    return list
        .map((dynamic e) => Person.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeDataToFile(Map<String, dynamic> data) async {
    final file = File('jsonfile/example.json');
    final jsonData = jsonEncode(data);
    print(jsonData);
    // await file.writeAsString(jsonData);
  }
}
