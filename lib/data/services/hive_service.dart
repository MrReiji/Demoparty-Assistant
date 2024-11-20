import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  /// Initializes Hive for local storage.
  static Future<void> initialize() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    print("[HiveService] Hive initialized at ${appDocDir.path}");
  }
}
