import 'package:demoparty_assistant/blocs/settings_form_bloc.dart';
import 'package:demoparty_assistant/data/services/settings_service.dart';
import 'package:demoparty_assistant/data/services/notification_service.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:demoparty_assistant/utils/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsFormBloc(
        GetIt.I<SettingsService>(),
        GetIt.I<NotificationService>(),
      ),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<SettingsFormBloc>();
          final theme = Theme.of(context);

          return Scaffold(
            appBar: AppBar(
              title: Text('Settings'),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            drawer: AppDrawer(currentPage: "Settings"),
            body: SafeArea(
              child: FormBlocListener<SettingsFormBloc, String, String>(
                onSubmitting: (context, state) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(child: CircularProgressIndicator()),
                  );
                },
                onSuccess: (context, state) {
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Settings saved successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                onFailure: (context, state) {
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failureResponse ?? 'Failed to save settings.'),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Notification Reminder Time',
                        style: theme.textTheme.headlineLarge?.copyWith(color: textColorLight),
                      ),
                      SizedBox(height: AppDimensions.paddingMedium),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: InputWidget(
                              hintText: 'Enter number',
                              textInputType: TextInputType.number,
                              fieldBloc: formBloc.reminderValue,
                            ),
                          ),
                          SizedBox(width: AppDimensions.paddingSmall),
                          Expanded(
                            flex: 2,
                            child: InputWidget(
                              hintText: 'Time Unit',
                              selectFieldBloc: formBloc.timeUnit,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.paddingLarge),
                      ElevatedButton(
                        onPressed: formBloc.submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                          ),
                          backgroundColor: theme.primaryColor,
                        ),
                        child: Text(
                          'Save Settings',
                          style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
