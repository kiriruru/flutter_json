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

  // Future<void> readConfig();
}

class LocalDataSource extends DataSource {
  LocalDataSource(dataPath, configPath) : super(dataPath, configPath);

  Future<dynamic> readLocalFile(localPath) async {
    final File fileData = File(localPath);
    final String jsonData = await fileData.readAsString();
    final data = jsonDecode(jsonData);
    return data;
  }

  @override
  Future<void> readData() async {
    final jsonData = await readLocalFile(dataPath);
    final jsonConfigParsed = await readLocalFile(configPath);

    // final File fileData = File(dataPath);
    // final String jsonData = await fileData.readAsString();
    // final data = jsonDecode(jsonData);

    final Map<String, Map<String, String>> finalMapFromJson = {};

    jsonConfigParsed.forEach((key, value) {
      finalMapFromJson[key] = value.cast<String, String>();
    });
    _jsonItem = jsonData;
    _config = finalMapFromJson;
    // final File file = File(configPath);
    // final String jsonConfig = await file.readAsString();
    // final Map<String, dynamic> jsonConfigParsed = jsonDecode(jsonConfig);
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
  // @override
  // Future<Map<String, Map<String, String>>> readConfig() async {
  //   final File file = File(configPath);
  //   final String jsonConfig = await file.readAsString();
  //   final Map<String, dynamic> jsonConfigParsed = jsonDecode(jsonConfig);

  //   final Map<String, Map<String, String>> finalMapFromJson = {};

  //   jsonConfigParsed.forEach((key, value) {
  //     finalMapFromJson[key] = value.cast<String, String>();
  //   });

  //   _config = finalMapFromJson;
  //   return _config;
  // }

}

// class HttpDataSource extends DataSource {
//   final String dataUrl;
//   final String configUrl;

//   HttpDataSource(this.dataUrl, this.configUrl);
//   Map<String, dynamic> _jsonItem = {};
//   Map<String, Map<String, String>> _config = {};

//   @override
//   Future<Map<String, dynamic>> readData() async {
//     final http.Response response = await http.get(Uri.parse(dataUrl));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       _jsonItem = data;
//       return _jsonItem;
//     } else {
//       throw Exception('Failed to load data from URL');
//     }
//   }

//   @override
//   Future<Map<String, Map<String, String>>> readConfig() async {
//     final http.Response response = await http.get(Uri.parse(configUrl));
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonConfigParsed = jsonDecode(response.body);
//       final Map<String, Map<String, String>> finalMapFromJson = {};

//       jsonConfigParsed.forEach((key, value) {
//         finalMapFromJson[key] = value.cast<String, String>();
//       });

//       _config = finalMapFromJson;
//       return _config;
//     } else {
//       throw Exception('Failed to load config from URL');
//     }
//   }

//   @override
//   Future<void> updateData(key, value) async {
//     if (_jsonItem[key] != value) {
//       final Map<String, dynamic> data = {key: value};
//       final http.Response response =
//           await http.patch(Uri.parse(dataUrl), body: jsonEncode(data));

//       if (response.statusCode != 200) {
//         //   throw Exception('Failed to update data');
//         await Future.delayed(Duration(seconds: 2));
//         print("Data has updated. New data are: $_jsonItem");
//       }
//     }
//   }
// }
