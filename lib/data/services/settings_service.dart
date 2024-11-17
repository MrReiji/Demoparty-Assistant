import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _reminderValueKey = 'reminderValue';
  static const String _reminderUnitKey = 'reminderUnit';

  static const int _defaultReminderValue = 32; // Domyślne 15 minut
  static const String _defaultReminderUnit = 'minutes';

  Future<void> setReminderSettings(int value, String unit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_reminderValueKey, value);
    await prefs.setString(_reminderUnitKey, unit);
  }

  Future<Map<String, dynamic>> getReminderSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int reminderValue = prefs.getInt(_reminderValueKey) ?? _defaultReminderValue;
    final String reminderUnit = prefs.getString(_reminderUnitKey) ?? _defaultReminderUnit;

    return {'value': reminderValue, 'unit': reminderUnit};
  }

  Future<int> getReminderTimeInMinutes() async {
    final settings = await getReminderSettings();
    final int value = settings['value'];
    final String unit = settings['unit'];

    switch (unit) {
      case 'minutes':
        return value;
      case 'hours':
        return value * 60;
      case 'days':
        return value * 1440;
      case 'weeks':
        return value * 10080;
      default:
        return _defaultReminderValue;
    }
  }
}
