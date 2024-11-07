import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:demoparty_assistant/constants/Theme.dart';

/// A refined input widget with dynamic styling based on ThemeData for a modern and clean UI.
class InputWidget extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final TextInputType? textInputType;
  final TextFieldBloc fieldBloc;

  const InputWidget({
    Key? key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.autofillHints,
    this.textInputType,
    required this.fieldBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXXSmall),
      child: TextFieldBlocBuilder(
        textFieldBloc: fieldBloc,
        suffixButton: obscureText ? SuffixButton.obscureText : null,
        autofillHints: autofillHints,
        keyboardType: textInputType,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
            fontSize: AppDimensions.paragraphFontSize,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: theme.iconTheme.color)
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon, color: theme.iconTheme.color),
                  onPressed: onSuffixIconPressed,
                )
              : null,
          filled: true,
          fillColor: Colors.grey[850],
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingMedium,
            horizontal: AppDimensions.paddingMedium,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
        ),
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
    );
  }
}
