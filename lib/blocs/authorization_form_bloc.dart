import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;

class AuthenticationFormBloc extends FormBloc<String, String> {
  // Fields for login
  final login = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final loginPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars
    ],
  );

  // Fields for registration
  final registerHandle = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final registerGroup = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final registerAccessKey = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final registerCountry = SelectFieldBloc<String, dynamic>(
    items: ['Germany', 'USA', 'France', 'Japan', 'Other'],
    validators: [FieldBlocValidators.required],
  );

  final registerPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars
    ],
  );

  final registerConfirmPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars
    ],
  );

  bool isLogin = true;
  String? sessionCookie; // Store session cookie for authenticated requests

  AuthenticationFormBloc() {
    debugPrint("Initializing AuthenticationFormBloc...");
    _addLoginFields();
  }

  // Toggle between login and registration mode
  void switchToRegistration() {
    debugPrint("Switching to Registration mode...");
    isLogin = false;
    clear();
    _addRegistrationFields();
  }

  void switchToLogin() {
    debugPrint("Switching to Login mode...");
    isLogin = true;
    clear();
    _addLoginFields();
  }

  // Add login fields to form
  void _addLoginFields() {
    debugPrint("Adding Login fields to form...");
    addFieldBlocs(fieldBlocs: [login, loginPassword]);
  }

  // Add registration fields to form
  void _addRegistrationFields() {
    debugPrint("Adding Registration fields to form...");
    addFieldBlocs(fieldBlocs: [
      registerHandle,
      registerGroup,
      registerAccessKey,
      registerCountry,
      registerPassword,
      registerConfirmPassword,
    ]);
  }

  // Handle form submission
  @override
  Future<void> onSubmitting() async {
    debugPrint("Form submission started...");
    try {
      if (isLogin) {
        debugPrint("Attempting login...");
        final response = await attemptHtmlLogin(
            login.value, loginPassword.value);

        if (response.isSuccess) {
          sessionCookie = response.sessionCookie; // Store session cookie
          debugPrint("Login successful. Session cookie: $sessionCookie");
          emitSuccess(successResponse: "Logged in successfully!");
        } else {
          debugPrint("Login failed.");
          emitFailure(
              failureResponse: "Login failed. Please check your credentials.");
        }
      } else {
        debugPrint("Attempting registration...");
        // Add registration logic here
        emitSuccess(successResponse: "Registered successfully!");
        debugPrint("Registration successful.");
      }
    } catch (error) {
      debugPrint("An error occurred during submission: $error");
      emitFailure(
          failureResponse: "An error occurred. Please try again later.");
    }
  }

  // Perform HTML login request with session management
  Future<LoginResponse> attemptHtmlLogin(
      String email, String password) async {
    debugPrint("Starting HTML login request...");
    final url = Uri.parse("https://party.xenium.rocks/visitors");
    final headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final body = {
      "visitor_login[login]": email,
      "visitor_login[password]": password,
      "login": "Log in"
    };

    debugPrint(
        "Sending POST request to $url with body $body and headers $headers...");
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 302) {
      final setCookieHeader = response.headers['set-cookie'];
      debugPrint("Login response: 302 Found. Set-Cookie header: $setCookieHeader");

      // Parse the 'Set-Cookie' header to extract 'session' and 'autologin_user_auth_visitor'
      final cookies =
          setCookieHeader?.split(RegExp(r',(?=\s*\w+=)'));

      final sessionCookies = <String>[];
      if (cookies != null) {
        for (var cookie in cookies) {
          final cookiePair = cookie.split(';').first.trim();
          final keyValue = cookiePair.split('=');
          if (keyValue.length == 2) {
            final key = keyValue[0];
            final value = keyValue[1];
            if (key == 'session' ||
                key == 'autologin_user_auth_visitor') {
              sessionCookies.add('$key=$value');
            }
          }
        }
      }

      final sessionCookie = sessionCookies.join('; ');
      debugPrint("Extracted session cookie: $sessionCookie");

      return LoginResponse(
          isSuccess: true, sessionCookie: sessionCookie);
    } else {
      debugPrint(
          "Login failed. Response status code: ${response.statusCode}");
      return LoginResponse(isSuccess: false);
    }
  }

  // Method for making authenticated requests using session cookie
  Future<http.Response> makeAuthenticatedRequest(String url) async {
    debugPrint("Making authenticated request to $url...");
    final headers = {"Cookie": sessionCookie ?? ""};

    final response = await http.get(Uri.parse(url), headers: headers);
    debugPrint(
        "Authenticated request response status: ${response.statusCode}");
    if (response.statusCode == 200) {
      debugPrint(
          "Authenticated request successful. Response body: ${response.body}");
    } else {
      debugPrint(
          "Authenticated request failed with status: ${response.statusCode}");
    }
    return response;
  }
}

// Class to represent the login response with session cookie
class LoginResponse {
  final bool isSuccess;
  final String? sessionCookie;

  LoginResponse({required this.isSuccess, this.sessionCookie});
}
