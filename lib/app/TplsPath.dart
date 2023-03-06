import 'package:pocketbase/pocketbase.dart';

abstract class TplPath {
  Future<String> getTplPath();
}

class PbTplPath extends TplPath {
  final String pbPath;
  final String id;

  PbTplPath({required this.pbPath, required this.id});

  late final PocketBase _pb;
  late final AdminAuth _authData;

  @override
  Future<String> getTplPath() async {
    _pb = PocketBase(pbPath);
    _authData = await _pb.admins
        .authWithPassword('alimardon007@gmail.com', '5544332211');
    final record = await _pb.collection('documents').getOne(id);
    final firstFilename = record.getListValue<String>('document')[0];
    return _pb.getFileUrl(record, firstFilename).toString();
  }
}
