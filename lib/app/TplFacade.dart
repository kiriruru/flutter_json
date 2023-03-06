import 'package:flutter_modular/flutter_modular.dart';
import 'package:pocketbase/pocketbase.dart';
import 'DataSource.dart';
import 'TplGenerator.dart';

abstract class TplFacade {
  final Map<String, String> templateData;
  TplFacade({required this.templateData});
  Future<void> generateDocument();
}

class TplFacadeRemote extends TplFacade {
  final String id;

  TplFacadeRemote({required this.id, required super.templateData});

  @override
  Future<void> generateDocument() async {
    final dataSource = Modular.get<DataSource>();
    final RecordModel record =
        await dataSource.pb.collection('documents').getOne(id);
    final String firstFilename = record.getListValue<String>('document')[0];
    final String fullTplPath =
        dataSource.pb.getFileUrl(record, firstFilename).toString();

    final TplGenerator _generator = TplGenerator(
      templateData: templateData,
      tplPath: fullTplPath,
      isRemoteFile: true,
      isAssetFile: false,
    );
    _generator.createDocument();
  }
}

class TplFacadeLocal extends TplFacade {
  final String tplPath;
  TplFacadeLocal({required this.tplPath, required super.templateData});
  @override
  Future<void> generateDocument() async {
    final TplGenerator _generator = TplGenerator(
      templateData: templateData,
      tplPath: tplPath,
      isRemoteFile: false,
      isAssetFile: true,
    );
  }
}
