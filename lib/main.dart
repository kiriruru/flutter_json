import 'app/PbAuth.dart';
import '../runner.dart';

final pocketBase = PocketBase("http://127.0.0.1:8090");
  
void main() async {
  await pocketBase.admins.authWithPassword('alimardon007@gmail.com', '5544332211');
  runner(pocketBase);
}
