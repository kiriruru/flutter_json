import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_js/app/TplFacade.dart';
import 'package:flutter_js/app/pbAuth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pocketbase/pocketbase.dart';
import 'app/DataSource.dart';
import 'customers/screen.dart';

void runner() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Oh noes! ${details.exception} ${details.stack}');
  };
  runZonedGuarded(
    () => runApp(ModularApp(module: AppModule(), child: AppWidget())),
    (error, stackTrace) => print('Oh noes! $error $stackTrace'),
  ); // старое, проверить
}

class AppWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Smart App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        // Bind.singleton((i) => PbAuth()),
        // Bind.singleton((i) => DataSource(pb, "assets/config.json")),
        Bind.singleton((i) => PocketBaseDataSource(pb, "assets/config.json")),
      ];

  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => HomePage()),
      ];
}
