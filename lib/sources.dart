class SourceOfData {
  final String dataPath;
  final String configPath;

  SourceOfData({required this.dataPath, required this.configPath});
}

SourceOfData localSource = SourceOfData(
  configPath: "assets/config.json",
  dataPath: 'assets/example.json',
);

SourceOfData httpSource = SourceOfData(
  configPath:
      "https://raw.githubusercontent.com/alimardonbegov/flutter_json/main/assets/config.json",
  dataPath:
      // "http://127.0.0.1:8090"
      'https://raw.githubusercontent.com/alimardonbegov/flutter_json/main/assets/exampleHttp.json',
);

SourceOfData pocketBaseSource = SourceOfData(
  configPath: "assets/config.json",
  dataPath: "http://127.0.0.1:8090",
);
