import 'package:pocketbase/pocketbase.dart';

class PbAuth {
  static PocketBase _pb = PocketBase("http://127.0.0.1:8090");
  PocketBase get pb => _pb;
  static auth() async {
    // _pb = PocketBase("http://127.0.0.1:8090");
    print("auth started");
    final AdminAuth authData = await _pb.admins
        .authWithPassword('alimardon007@gmail.com', '5544332211');
    print("auth finished");

  }
}
