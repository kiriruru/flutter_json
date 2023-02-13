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
      'https://raw.githubusercontent.com/alimardonbegov/flutter_json/main/assets/exampleHttp.json',
);
