import 'package:demoparty_assistant/data/repositories/news_repository.dart';
import 'package:demoparty_assistant/data/repositories/time_table_repository.dart';
import 'package:demoparty_assistant/data/services/NativeCalendarService.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/data/services/news_content_service.dart';
import 'package:demoparty_assistant/data/services/hive_service.dart';
import 'package:demoparty_assistant/data/services/notification_service.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/data/latest.dart' as tz;

final GetIt locator = GetIt.instance;

class ServiceManager {
  /// Initializes all services and repositories.
  static Future<void> initialize() async {
    print("[ServiceManager] Starting initialization...");

    // Global timezone initialization
    print("[ServiceManager] Initializing timezone...");
    tz.initializeTimeZones();
    print("[ServiceManager] Timezone initialized.");

    // Initialize Hive
    print("[ServiceManager] Initializing Hive...");
    await HiveService.initialize();
    print("[ServiceManager] Hive initialized.");

    // Initialize and register services
    print("[ServiceManager] Registering services...");
    final cacheService = CacheService();
    await cacheService.initialize(); // Ensure cache box is opened before usage
    locator.registerSingleton<CacheService>(cacheService);
    locator.registerLazySingleton(() => NotificationService());
    locator.registerLazySingleton(() => NativeCalendarService());
    locator.registerLazySingleton(() => NewsContentService(locator()));
    print("[ServiceManager] Services registered.");

    // Initialize and register repositories
    print("[ServiceManager] Registering repositories...");
    locator.registerLazySingleton(() => NewsRepository(locator()));

    locator.registerLazySingleton<TimeTableRepository>(() {
      final repository = TimeTableRepository(
        locator<CacheService>(),
        locator<NotificationService>(),
        locator<NativeCalendarService>(),
      );
      return repository;
    });
    print("[ServiceManager] Repositories registered.");

    // Wait for all async registrations to complete
    await locator.allReady();
    print("[ServiceManager] All services and repositories initialized.");
  }
}
