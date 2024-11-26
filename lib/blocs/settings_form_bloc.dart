import 'package:demoparty_assistant/data/services/settings_service.dart';
import 'package:demoparty_assistant/data/services/notification_service.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

/// Handles notification settings form with form bloc functionality.
class NotificationSettingsFormBloc extends FormBloc<String, String> {
  // TextFieldBloc for reminder value (e.g., 15 minutes, 2 hours).
  final TextFieldBloc reminderValue = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      numberValidator, // Ensure the value is a positive number.
    ],
  );

  // SelectFieldBloc for the time unit (e.g., minutes, hours, days).
  final SelectFieldBloc<String, dynamic> timeUnit = SelectFieldBloc<String, dynamic>(
    items: ['minutes', 'hours', 'days', 'weeks'], // Available time units.
    validators: [FieldBlocValidators.required], // Ensure a unit is selected.
  );

  final SettingsService _settingsService;
  final NotificationService _notificationService;

  /// Constructor with dependency injection for required services.
  NotificationSettingsFormBloc(this._settingsService, this._notificationService) {
    print("[NotificationSettingsFormBloc] Initializing NotificationSettingsFormBloc.");
    addFieldBlocs(fieldBlocs: [reminderValue, timeUnit]);
    _loadInitialValues(); // Load initial settings on initialization.
  }

  /// Loads initial notification settings into the form fields.
  Future<void> _loadInitialValues() async {
    print("[NotificationSettingsFormBloc] Loading initial values for notification settings.");
    try {
      final settings = await _settingsService.getReminderSettings();
      reminderValue.updateInitialValue(settings['value'].toString());
      timeUnit.updateInitialValue(settings['unit']);
      print("[NotificationSettingsFormBloc] Initial values loaded successfully.");
    } catch (e) {
      print("[NotificationSettingsFormBloc] Error loading initial values: $e");
      emitFailure(failureResponse: "Failed to load initial values.");
    }
  }

  @override
  Future<void> onSubmitting() async {
    print("[NotificationSettingsFormBloc] Submitting form data.");
    try {
      final value = int.parse(reminderValue.value); // Parse reminder value.
      final unit = timeUnit.value;

      print("[NotificationSettingsFormBloc] Saving settings: value = $value, unit = $unit.");
      await _settingsService.setReminderSettings(value, unit!); // Save the settings.

      // Update notifications with the new settings.
      print("[NotificationSettingsFormBloc] Re-scheduling notifications with new settings.");
      await _notificationService.cancelAllNotifications(); // Cancel existing notifications.
      await _notificationService.rescheduleAllNotifications(); // Reschedule notifications.

      print("[NotificationSettingsFormBloc] Settings saved and notifications updated successfully.");
      emitSuccess(successResponse: 'Notification settings saved successfully!');
    } catch (e) {
      print("[NotificationSettingsFormBloc] Error saving settings or rescheduling notifications: $e");
      emitFailure(failureResponse: 'Failed to save notification settings.');
    }
  }
}

/// Validates the number input for the reminder value.
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
