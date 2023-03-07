import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_js/app/TplFacade.dart';
import 'package:flutter_js/app/pbAuth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pocketbase/pocketbase.dart';
import 'app/DataSource.dart';
import 'customers/screen.dart';

void runner() async {
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
        // AsyncBind<PocketBase>((i) async {
        //   print("asyncBind started");
        //   final PocketBase pb = PocketBase("http://127.0.0.1:8090");
        //   final AdminAuth authData = await pb.admins
        //       .authWithPassword('alimardon007@gmail.com', '5544332211');
        //   return pb;
        // }),

        // Bind.factory((i) {
        //   print("factory bind started");
        //   return PocketBase("http://127.0.0.1:8090");
        // }), //! работает
        Bind.singleton(
            (i) => PocketBaseDataSource(PbAuth().pb, "assets/config.json")),
      ];

  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => HomePage()),
      ];
}
