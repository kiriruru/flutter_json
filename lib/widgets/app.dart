import 'package:flutter/material.dart';
import 'package:flutter_js/interface.dart';
import 'package:flutter_js/sources.dart';
import 'package:flutter_js/widgets/main_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(
        dataSource: LocalDataSource(
          localSource.dataPath,
          localSource.configPath,
        ),
        // HttpDataSource(
        //   httpSource.dataPath,
        //   httpSource.configPath,
        // ),
      ),
    );
  }
}
