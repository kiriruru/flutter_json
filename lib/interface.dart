import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

abstract class DataSource {
  final String dataPath;
  final String configPath;
  DataSource(this.dataPath, this.configPath);

  late Map<String, dynamic> _jsonItem;
  late Map<String, Map<String, String>> _config;

  Map<String, dynamic> get jsonItem => _jsonItem;
  Map<String, Map<String, String>> get config => _config;

  Future<void> readData();
  Future<void> updateData(key, value);
}

class LocalDataSource extends DataSource {
  LocalDataSource(dataPath, configPath) : super(dataPath, configPath);

  Future<dynamic> readLocalFile(localPath) async {
    final File fileData = File(localPath);
    final String jsonData = await fileData.readAsString();
    return jsonDecode(jsonData);
  }

  @override
  Future<void> readData() async {
    final jsonData = await readLocalFile(dataPath);
    final jsonConfigParsed = await readLocalFile(configPath);
    final Map<String, Map<String, String>> finalMapFromJson = {};
    jsonConfigParsed.forEach((key, value) {
      finalMapFromJson[key] = value.cast<String, String>();
    });

    _jsonItem = jsonData;
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
}

class HttpDataSource extends DataSource {
  HttpDataSource(dataPath, configPath) : super(dataPath, configPath);

  Future<dynamic> readHttpInf(url) async {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  @override
  Future<void> readData() async {
    final jsonData = await readHttpInf(dataPath);
    final jsonConfigParsed = await readHttpInf(configPath);
    final Map<String, Map<String, String>> finalMapFromJson = {};
    jsonConfigParsed.forEach((key, value) {
      finalMapFromJson[key] = value.cast<String, String>();
    });

    _jsonItem = jsonData;
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
}
