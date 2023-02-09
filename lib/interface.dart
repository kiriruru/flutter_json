import 'dart:convert';
import 'dart:io';

abstract class DataSource {
  Future<Map<String, dynamic>> readData();
  Future<Map<String, Map<String, String>>> readConfig();
  Future<void> updateData(key, value);
}

class LocalJsonMap extends DataSource {
  final String dataPath;
  final String configPath;

  LocalJsonMap(this.dataPath, this.configPath);
  Map<String, dynamic> _jsonItem = {};
  Map<String, Map<String, String>> _config = {};

  @override
  Future<Map<String, dynamic>> readData() async {
    final File file = File(dataPath);
    final String jsonData = await file.readAsString();
    final data = jsonDecode(jsonData);
    _jsonItem = data;
    print("data has read $_jsonItem");
    return _jsonItem;
  }

  @override
  Future<Map<String, Map<String, String>>> readConfig() async {
    final File file = File(configPath);
    final String jsonConfig = await file.readAsString();
    final Map<String, dynamic> jsonConfigParsed = jsonDecode(jsonConfig);

    final Map<String, Map<String, String>> finalMapFromJson = {};

    jsonConfigParsed.forEach((key, value) {
      finalMapFromJson[key] = value.cast<String, String>();
    });

    _config = finalMapFromJson;
    print("config has read $_config");
    return _config;
  }

  @override
  Future<void> updateData(key, value) async {
    if (_jsonItem[key] != value) {
      final File file = File(dataPath);
      _jsonItem[key] = value;
      final jsonDataUpdated = jsonEncode(_jsonItem);
      await file.writeAsString(jsonDataUpdated);
      print("file has updated $_jsonItem");
    }
  }
}
