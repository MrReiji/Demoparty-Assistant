import 'package:demoparty_assistant/data/repositories/news_repository.dart';
import 'package:demoparty_assistant/data/repositories/news_content_repository.dart';
import 'package:demoparty_assistant/data/repositories/time_table_repository.dart';
import 'package:demoparty_assistant/data/services/hive_service.dart';
import 'package:demoparty_assistant/data/services/settings_service.dart';
import 'package:demoparty_assistant/data/services/notification_service.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/data/services/news_content_service.dart';
import 'package:demoparty_assistant/data/services/NativeCalendarService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final GetIt locator = GetIt.instance;

class ServiceManager {
  static Future<void> initialize() async {
    print("[ServiceManager] Starting initialization...");
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));

    print("[ServiceManager] Initializing Hive...");
    await HiveService.initialize();

    // Rejestruj SettingsService przed CacheService
    locator.registerLazySingleton(() => SettingsService());

    final cacheService = CacheService();
    await cacheService.initialize();
    locator.registerSingleton<CacheService>(cacheService);

    locator.registerLazySingleton(() => NotificationService());
    locator.registerLazySingleton(() => NativeCalendarService());
    locator.registerLazySingleton(() => NewsContentRepository());
    locator.registerLazySingleton(() => NewsContentService(locator<NewsContentRepository>()));
    locator.registerLazySingleton(() => NewsRepository());
    locator.registerLazySingleton(() => const FlutterSecureStorage());

    locator.registerLazySingleton<TimeTableRepository>(() {
      return TimeTableRepository(
        locator<CacheService>(),
        locator<NotificationService>(),
        locator<NativeCalendarService>(),
      );
    });

    await locator.allReady();
    print("[ServiceManager] All services and repositories initialized.");
  }
}

