import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './classes/DataSource.dart';
import './widgets/home_page.dart';

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
  final DataSource dataSourceIns = PocketBaseDataSource(
    "http://127.0.0.1:8090",
    "assets/config.json",
    "6o8x3dj0mvkemyn",
  );
  @override
  List<Bind> get binds => [Bind.singleton((i) => dataSourceIns)];

  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => HomePage()),
      ];
}
