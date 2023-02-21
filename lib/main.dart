import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app/DataSource.dart';
import 'customers/screen.dart';

void main() async {
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

class AppWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Smart App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    ); //added by extension
  }
}

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => PocketBaseDataSource(
              "http://127.0.0.1:8090",
              "assets/config.json",
            ))
      ];

  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => HomePage()),
      ];
}
