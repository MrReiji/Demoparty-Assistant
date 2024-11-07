import 'package:demoparty_assistant/blocs/authorization_form_bloc.dart';
import 'package:demoparty_assistant/utils/navigation/app_router_paths.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:demoparty_assistant/utils/widgets/input_widget.dart';
import 'package:go_router/go_router.dart';

/// Authentication screen widget
class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<AuthenticationFormBloc>();
          final theme = Theme.of(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                formBloc.isLogin ? "Login" : "Registration",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (formBloc.isLogin) {
                      formBloc.switchToRegistration();
                    } else {
                      formBloc.switchToLogin();
                    }
                    setState(() {});
                  },
                  child: Text(
                    formBloc.isLogin ? "Switch to Registration" : "Switch to Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            drawer: AppDrawer(currentPage: "Authentication"),
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: FormBlocListener<AuthenticationFormBloc, String, String>(
                onSubmitting: (context, state) {
                  CircularProgressIndicator(
                color: theme.colorScheme.primary,
              );
                },
                onSuccess: (context, state) {
                  // Pobierz ciasteczko sesji po udanym logowaniu
                  final sessionCookie = formBloc.sessionCookie;

                  // Przekierowanie do ekranu Voting z przekazaniem sessionCookie jako `extra`
                  context.go(
                    AppRouterPaths.voting,
                    extra: sessionCookie,
                  );
                },
                onFailure: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse ?? "Submission Failed")),
                  );
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (formBloc.isLogin) ...[
                        Text(
                          "Login",
                          style: theme.textTheme.headlineLarge?.copyWith(color: textColorLight),
                        ),
                        SizedBox(height: AppDimensions.paddingSmall),
                        InputWidget(
                          hintText: "Email",
                          prefixIcon: Icons.email,
                          fieldBloc: formBloc.login,
                        ),
                        InputWidget(
                          hintText: "Password",
                          prefixIcon: Icons.lock,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          onSuffixIconPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          fieldBloc: formBloc.loginPassword,
                        ),
                        SizedBox(height: AppDimensions.paddingMedium),
                        PrimaryButton(
                          text: "LOG IN",
                          press: formBloc.submit,
                          color: theme.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
                        ),
                      ] else ...[
                        Text(
                          "Registration",
                          style: theme.textTheme.headlineLarge?.copyWith(color: textColorLight),
                        ),
                        SizedBox(height: AppDimensions.paddingSmall),
                        InputWidget(
                          hintText: "Handle",
                          prefixIcon: Icons.person,
                          fieldBloc: formBloc.registerHandle,
                        ),
                        InputWidget(
                          hintText: "Group",
                          prefixIcon: Icons.group,
                          fieldBloc: formBloc.registerGroup,
                        ),
                        _buildDropdownField("Country", formBloc.registerCountry, theme),
                        InputWidget(
                          hintText: "Access Key",
                          prefixIcon: Icons.vpn_key,
                          fieldBloc: formBloc.registerAccessKey,
                        ),
                        SizedBox(height: AppDimensions.paddingSmall),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Scan ticket action
                          },
                          icon: Icon(FontAwesomeIcons.qrcode, size: AppDimensions.iconSizeSmall),
                          label: Text("SCAN TICKET"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimensions.paddingMedium),
                        InputWidget(
                          hintText: "Password",
                          prefixIcon: Icons.lock,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          onSuffixIconPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          fieldBloc: formBloc.registerPassword,
                        ),
                        InputWidget(
                          hintText: "Repeat Password",
                          prefixIcon: Icons.lock,
                          obscureText: !_isConfirmPasswordVisible,
                          suffixIcon: _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          onSuffixIconPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                          fieldBloc: formBloc.registerConfirmPassword,
                        ),
                        SizedBox(height: AppDimensions.paddingMedium),
                        ElevatedButton(
                          onPressed: formBloc.submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                            ),
                          ),
                          child: Text(
                            "Register",
                            style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
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

  Widget _buildDropdownField(String label, SelectFieldBloc<String, dynamic> fieldBloc, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXSmall),
      child: DropdownFieldBlocBuilder<String>(
        selectFieldBloc: fieldBloc,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(color: mutedTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          filled: true,
          fillColor: Colors.grey[850],
        ),
        itemBuilder: (context, value) => FieldItem(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(color: textColorLight),
          ),
        ),
      ),
    );
  }
}
