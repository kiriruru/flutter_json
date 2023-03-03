import 'package:pocketbase/pocketbase.dart';

abstract class TeamplateSource {
  final String tplPath;
  TeamplateSource(this.tplPath);

  // Future<File> getDocument();
  Future<String> getDocumentPath(String tplName);
}

class PocketBaseTeamplateSource extends TeamplateSource {
  PocketBaseTeamplateSource(super.tplPath);
  late final PocketBase _pb;
  late final AdminAuth _authData;

  @override
  Future<String> getDocumentPath(String tplName) async {
    _pb = PocketBase(tplPath);
    _authData = await _pb.admins
        .authWithPassword('alimardon007@gmail.com', '5544332211');
    final record = await _pb.collection('documents').getOne("2sylungy3q251b9");
    final firstFilename = record.getListValue<String>('document')[0];
    return _pb.getFileUrl(record, firstFilename).toString();
  }
}
