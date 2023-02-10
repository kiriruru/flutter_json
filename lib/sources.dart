class SourceOfData {
  final String source;
  final String dataPath;
  final String configPath;

  SourceOfData(
      {required this.source, required this.dataPath, required this.configPath});
}

SourceOfData localSource = SourceOfData(
  configPath: "assets/config.json",
  dataPath: 'assets/example.json',
  source: 'local',
);

SourceOfData httpSource = SourceOfData(
  configPath:
      "https://raw.githubusercontent.com/alimardonbegov/flutter_json/main/assets/config.json",
  dataPath:
      'https://raw.githubusercontent.com/alimardonbegov/flutter_json/main/assets/exampleHttp.json',
  source: 'http',
);
