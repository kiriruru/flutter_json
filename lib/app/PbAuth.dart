import 'package:pocketbase/pocketbase.dart';

class PbAuth {
  Future<PocketBase> auth() async {
    final PocketBase pb = PocketBase("http://127.0.0.1:8090");
    final AdminAuth authData = await pb.admins
        .authWithPassword('alimardon007@gmail.com', '5544332211');
    return pb;
  }
}
