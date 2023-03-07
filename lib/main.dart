import 'app/PbAuth.dart';
import '../runner.dart';

void main() async {
  await PbAuth.auth();
  runner();
}
