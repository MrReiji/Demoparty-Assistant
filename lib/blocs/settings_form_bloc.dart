import 'package:demoparty_assistant/data/services/settings_service.dart';
import 'package:demoparty_assistant/data/services/notification_service.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class SettingsFormBloc extends FormBloc<String, String> {
  final TextFieldBloc reminderValue = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      numberValidator,
    ],
  );

  final SelectFieldBloc<String, dynamic> timeUnit = SelectFieldBloc<String, dynamic>(
    items: ['minutes', 'hours', 'days', 'weeks'],
    validators: [FieldBlocValidators.required],
  );

  final SettingsService _settingsService;
  final NotificationService _notificationService;

  /// Constructor with dependency injection
  SettingsFormBloc(this._settingsService, this._notificationService) {
    print("[SettingsFormBloc] Initializing SettingsFormBloc.");
    addFieldBlocs(fieldBlocs: [reminderValue, timeUnit]);
    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    print("[SettingsFormBloc] Loading initial values for settings.");
    try {
      final settings = await _settingsService.getReminderSettings();
      reminderValue.updateInitialValue(settings['value'].toString());
      timeUnit.updateInitialValue(settings['unit']);
      print("[SettingsFormBloc] Initial values loaded successfully.");
    } catch (e) {
      print("[SettingsFormBloc] Error loading initial values: $e");
      emitFailure(failureResponse: "Failed to load initial values.");
    }
  }

  @override
  Future<void> onSubmitting() async {
    print("[SettingsFormBloc] Submitting form data.");
    try {
      final value = int.parse(reminderValue.value);
      final unit = timeUnit.value;

      print("[SettingsFormBloc] Saving settings: value = $value, unit = $unit.");
      await _settingsService.setReminderSettings(value, unit!);

      // Cancel existing notifications and reschedule with new settings
      print("[SettingsFormBloc] Re-scheduling notifications with new settings.");
      await _notificationService.cancelAllNotifications();
      await _notificationService.rescheduleAllNotifications();

      print("[SettingsFormBloc] Settings saved and notifications updated successfully.");
      emitSuccess(successResponse: 'Settings saved successfully!');
    } catch (e) {
      print("[SettingsFormBloc] Error saving settings or rescheduling notifications: $e");
      emitFailure(failureResponse: 'Failed to save settings.');
    }
  }
}

String? numberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required.';
  }
  final number = num.tryParse(value);
  if (number == null || number <= 0) {
    return 'Enter a valid number greater than 0.';
  }
  return null;
}
