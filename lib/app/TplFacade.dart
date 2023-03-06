import 'package:pocketbase/pocketbase.dart';

import 'TplGenerator.dart';
import 'TplsPath.dart';

abstract class TplFacade {
  Future<void> generateDocument();
}

class TplFacadeRemote extends TplFacade {
  final String id;
  final Map<String, String> templateData;
  TplFacadeRemote({required this.id, required this.templateData});

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
  TplFacadeLocal({required this.tplPath});
  @override
  Future<void> generateDocument() async {
    final TplGenerator _generator = TplGenerator(
      templateData: {},
      tplPath: tplPath,
      isRemoteFile: false,
      isAssetFile: true,
    );
  }
}

// TplFacadeOld {
    // void generateTplFromRemote(
  //   String id,
  //   Map<String, String> templateData,
  // ) async {
  //   final TplPath _path = PbTplPath(
  //     pbPath: "http://127.0.0.1:8090",
  //     id: id,
  //   );
  //   final String fullTplPath = await _path.getTplPath();

  //   final TplGenerator _generator = TplGenerator(
  //     templateData: templateData,
  //     tplPath: fullTplPath,
  //     isRemoteFile: true,
  //     isAssetFile: false,
  //   );
  //   _generator.createDocument();
  // }

  // void generateTplFromLocal(String tplPath) async {
  //   final TplGenerator _generator = TplGenerator(
  //     templateData: {},
  //     tplPath: tplPath,
  //     isRemoteFile: false,
  //     isAssetFile: true,
  //   );
  // }
// }