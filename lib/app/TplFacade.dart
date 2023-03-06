import 'package:pocketbase/pocketbase.dart';
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
    final PocketBase _pb = PocketBase("http://127.0.0.1:8090");
    final AdminAuth _authData = await _pb.admins
        .authWithPassword('alimardon007@gmail.com', '5544332211');
    final RecordModel record = await _pb.collection('documents').getOne(id);
    final String firstFilename = record.getListValue<String>('document')[0];
    final String fullTplPath = _pb.getFileUrl(record, firstFilename).toString();

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
