import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class AuthorizationFormBloc extends FormBloc<String, String> {
  // Fields for login
  final login = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final loginPassword = TextFieldBloc(validators: [
    FieldBlocValidators.required,
    FieldBlocValidators.passwordMin6Chars,
  ]);

  // Fields for registration
  final registerHandle = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final registerGroup = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final registerAccessKey = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final registerCountry = SelectFieldBloc<String, dynamic>(
    items: ['Germany', 'USA', 'France', 'Japan', 'Other'],
    validators: [FieldBlocValidators.required],
  );
  final registerPassword = TextFieldBloc(validators: [
    FieldBlocValidators.required,
    FieldBlocValidators.passwordMin6Chars,
  ]);
  final registerConfirmPassword = TextFieldBloc(validators: [
    FieldBlocValidators.required,
    FieldBlocValidators.passwordMin6Chars,
  ]);

  // Dependencies
  final _storage = GetIt.I<FlutterSecureStorage>();
  bool isLogin = true;
  bool isLoggedIn = false;
  String? sessionCookie;
  DateTime? cookieExpiry;

  /// Constructor for initializing the bloc
  AuthorizationFormBloc() {
    _addLoginFields();
  }

  /// Toggles to registration mode and resets fields.
  void switchToRegistration() {
    debugPrint("Switching to registration mode.");
    isLogin = false;
    clear();
    _addRegistrationFields();
  }

  /// Toggles to login mode and resets fields.
  void switchToLogin() {
    debugPrint("Switching to login mode.");
    isLogin = true;
    clear();
    _addLoginFields();
  }

  /// Adds login fields to the form.
  void _addLoginFields() {
    debugPrint("Adding login fields to the form.");
    addFieldBlocs(fieldBlocs: [login, loginPassword]);
  }

  /// Adds registration fields to the form.
  void _addRegistrationFields() {
    debugPrint("Adding registration fields to the form.");
    addFieldBlocs(fieldBlocs: [
      registerHandle,
      registerGroup,
      registerAccessKey,
      registerCountry,
      registerPassword,
      registerConfirmPassword,
    ]);
  }

  /// Logs the user out and resets the form to the login state.
  void logout() async {
    debugPrint("Logging out the user.");
    isLoggedIn = false;
    sessionCookie = null;
    cookieExpiry = null;
    await _storage.delete(key: 'session_cookie');
    await _storage.delete(key: 'cookie_expiry');
    clear();
    switchToLogin();
    emitSuccess(successResponse: "Logged out successfully!");
  }

  /// Handles form submission for login or registration.
  @override
Future<void> onSubmitting() async {
  debugPrint("Form submission started. isLogin: $isLogin");

  try {
    debugPrint("isLogin: $isLogin");
    if (isLogin) {
      final url = Uri.parse("https://party.xenium.rocks/visitors");
      final headers = {"Content-Type": "application/x-www-form-urlencoded"};
      final body = {
        "visitor_login[login]": login.value,
        "visitor_login[password]": loginPassword.value,
        "login": "Log in"
      };

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 302) {
        final cookies = response.headers['set-cookie']?.split(RegExp(r',(?=\s*\w+=)')) ?? [];
        sessionCookie = cookies
            .where((cookie) => cookie.contains('session') || cookie.contains('autologin_user_auth_visitor'))
            .map((cookie) => cookie.split(';').first.trim())
            .join('; ');

        // Extract expiry date from cookies or set a default duration
        final expiryMatch = RegExp(r'Expires=(.*?);').firstMatch(response.headers['set-cookie'] ?? '');
        if (expiryMatch != null) {
          cookieExpiry = DateTime.parse(expiryMatch.group(1)!);
        } else {
          // Default expiry: 7 days from now
          cookieExpiry = DateTime.now().add(Duration(days: 7));
        }

        isLoggedIn = true;

        // Save session data
        await _storage.write(key: 'session_cookie', value: sessionCookie);
        await _storage.write(key: 'cookie_expiry', value: cookieExpiry!.toIso8601String());
        await _storage.write(key: 'user_name', value: login.value);

        emitSuccess(successResponse: "Logged in successfully!");
      } else {
        emitFailure(failureResponse: "Login failed. Check your credentials.");
      }
    } else {
      debugPrint("Attempting registration.");
      // Placeholder for registration logic
      emitSuccess(successResponse: "Registered successfully!");
    }
  } catch (error) {
    emitFailure(failureResponse: "An error occurred: $error");
  }
}
}
