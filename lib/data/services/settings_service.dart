import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _reminderValueKey = 'reminderValue';
  static const String _reminderUnitKey = 'reminderUnit';

  static const int _defaultReminderValue = 32; // Default 15 minutes
  static const String _defaultReminderUnit = 'minutes';

  Future<void> setReminderSettings(int value, String unit) async {
    print("[SettingsService] Saving reminder settings: value = $value, unit = $unit");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_reminderValueKey, value);
      await prefs.setString(_reminderUnitKey, unit);
      print("[SettingsService] Reminder settings saved successfully.");
    } catch (e) {
      print("[SettingsService] Error saving reminder settings: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getReminderSettings() async {
    print("[SettingsService] Fetching reminder settings.");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int reminderValue = prefs.getInt(_reminderValueKey) ?? _defaultReminderValue;
      final String reminderUnit = prefs.getString(_reminderUnitKey) ?? _defaultReminderUnit;

      print("[SettingsService] Reminder settings fetched: value = $reminderValue, unit = $reminderUnit");
      return {'value': reminderValue, 'unit': reminderUnit};
    } catch (e) {
      print("[SettingsService] Error fetching reminder settings: $e");
      rethrow;
    }
  }

  Future<int> getReminderTimeInMinutes() async {
    print("[SettingsService] Calculating reminder time in minutes.");
    try {
      final settings = await getReminderSettings();
      final int value = settings['value'];
      final String unit = settings['unit'];

      int result;
      switch (unit) {
        case 'minutes':
          result = value;
          break;
        case 'hours':
          result = value * 60;
          break;
        case 'days':
          result = value * 1440;
          break;
        case 'weeks':
          result = value * 10080;
          break;
        default:
          result = _defaultReminderValue;
      }

      print("[SettingsService] Calculated reminder time: $result minutes.");
      return result;
    } catch (e) {
      print("[SettingsService] Error calculating reminder time: $e");
      rethrow;
    }
  }
}
