import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../utils/SourceOfData.dart';
import './config_inputs.dart';
import '../classes/DataSource.dart';

class MainPage extends StatelessWidget {
  SourceOfData pocketBaseSource = SourceOfData(
    configPath: "assets/config.json",
    dataPath: "http://127.0.0.1:8090",
    id: "6o8x3dj0mvkemyn",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Json")),
      body: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Expanded(child: UsersListWidget()),
            Expanded(
                child: ConfigInputsWidget(
              dataSource: PocketBaseDataSource(
                pocketBaseSource.dataPath,
                pocketBaseSource.configPath,
                pocketBaseSource.id,
              ),
              // LocalDataSource(
              //   localSource.dataPath,
              //   localSource.configPath,
              // ),
              // HttpDataSource(
              //   httpSource.dataPath,
              //   httpSource.configPath,
              // ),
            )),
          ],
        ),
      ),
    );
  }
}

class UsersListWidget extends StatelessWidget {
  UsersListWidget({
    Key? key,
  }) : super(key: key);

  List<RecordModel> usersList = [];

  Future<bool> getUsers() async {
    // await dataso
    final pb = PocketBase('http://127.0.0.1:8090');
    final authData = await pb.admins
        .authWithPassword('alimardon007@gmail.com', '5544332211');
    final records = await pb.collection('testUsers').getFullList();
    usersList = records;
    print("usersList: $usersList");

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsers(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: usersList
                  .map((e) => ListTile(
                        leading: Icon(Icons.person),
                        title: Text("${e.data["json"]["name"]}"),
                        subtitle: Text("${e.data["json"]["email"]}"),
                        onTap: () {},
                      ))
                  .toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("Something went wrong");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
