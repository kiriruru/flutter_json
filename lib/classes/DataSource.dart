import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

abstract class DataSource {
  final String dataPath;
  final String configPath;
  final String id;
  DataSource(this.dataPath, this.configPath, this.id);

  late final Map<String, dynamic> _jsonItem;
  late final Map<String, Map<String, String>> _config;
  late final List<dynamic> _usersList;

  Map<String, dynamic> get jsonItem => _jsonItem;
  Map<String, Map<String, String>> get config => _config;
  List<dynamic> get usersList => _usersList;

  Future<void> readData();
  Future<void> updateData(key, value);
  Future<void> getUsersData();
}

class LocalDataSource extends DataSource {
  LocalDataSource(super.dataPath, super.configPath, super.id);

  Future<dynamic> _readLocalFile(localPath) async {
    final File fileData = File(localPath);
    final String jsonData = await fileData.readAsString();
    return jsonDecode(jsonData);
  }

  @override
  Future<void> readData() async {
    final jsonData = await _readLocalFile(dataPath);
    _jsonItem = jsonData;

    final jsonConfigParsed = await _readLocalFile(configPath);
    final Map<String, Map<String, String>> finalMapFromJson = {};
    jsonConfigParsed.forEach((key, value) {
      finalMapFromJson[key] = value.cast<String, String>();
    });

    _config = finalMapFromJson;
  }

  @override
  Future<void> updateData(key, value) async {
    if (_jsonItem[key] != value) {
      final File file = File(dataPath);
      _jsonItem[key] = value;
      final jsonDataUpdated = jsonEncode(_jsonItem);
      await file.writeAsString(jsonDataUpdated);
    }
  }

  @override
  Future<void> getUsersData() async {}
}

class HttpDataSource extends DataSource {
  HttpDataSource(super.dataPath, super.configPath, super.id);
  Future<dynamic> _readHttpInf(url) async {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  @override
  Future<void> readData() async {
    final jsonData = await _readHttpInf(dataPath);
    _jsonItem = jsonData;

    final jsonConfigParsed = await _readHttpInf(configPath);
    final Map<String, Map<String, String>> finalMapFromJson = {};
    jsonConfigParsed.forEach((key, value) {
      finalMapFromJson[key] = value.cast<String, String>();
    });

    _config = finalMapFromJson;
  }

  @override
  Future<void> updateData(key, value) async {
    if (_jsonItem[key] != value) {
      final Map<String, dynamic> data = {key: value};
      final http.Response response =
          await http.patch(Uri.parse(dataPath), body: jsonEncode(data));
      if (response.statusCode != 200) {
        await Future.delayed(Duration(seconds: 2));
        print("Data has updated. New data are: $_jsonItem");
      }
    }
  }

  @override
  Future<void> getUsersData() async {}
}

class PocketBaseDataSource extends DataSource {
  PocketBaseDataSource(super.dataPath, super.configPath, super.id);

  @override
  Future<void> getUsersData() async {
    final pb = PocketBase(dataPath);
    final authData = await pb.admins
        .authWithPassword('alimardon007@gmail.com', '5544332211');

    final records = await pb.collection('testUsers').getFullList();
    _usersList = records;
  }

  @override
  Future<void> readData() async {
    final pb = PocketBase(dataPath);
    final authData = await pb.admins
        .authWithPassword('alimardon007@gmail.com', '5544332211');

    if (id != null) {
      try {
        final record = await pb.collection('testUsers').getOne(id);
        _jsonItem = record.data["json"];
      } catch (e) {
        print("error fetchin data by this id: $id");
      }
    } else {
      print("There is no data");
      _jsonItem = Map();
    }

    final File fileData = File(configPath);
    final String jsonData = await fileData.readAsString();
    final jsonConfigParsed = jsonDecode(jsonData);
    final Map<String, Map<String, String>> finalMapFromJson = {};
    jsonConfigParsed.forEach((key, value) {
      finalMapFromJson[key] = value.cast<String, String>();
    });

    _config = finalMapFromJson;
  }

  @override
  Future<void> updateData(key, value) async {
    if (_jsonItem[key] != value) {
      final pb = PocketBase("http://127.0.0.1:8090");
      final authData = await pb.admins
          .authWithPassword('alimardon007@gmail.com', '5544332211');

      _jsonItem[key] = value;
      final jsonDataUpdated = jsonEncode(_jsonItem);

      final body = <String, dynamic>{"json": jsonDataUpdated};
      await pb.collection('testUsers').update('6o8x3dj0mvkemyn', body: body);
    }
  }
}
