import 'app.dart';
import 'core/core.dart';

Future<void> main() async {
  F.appFlavor = Flavor.dev;
  Startup.run();
}
