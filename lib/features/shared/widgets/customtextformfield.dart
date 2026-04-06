import 'package:finmate/core/themes/app_color.dart';
import 'package:finmate/core/themes/app_textstyle.dart';
import 'package:finmate/core/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFieldWithLabel extends StatelessWidget {
  final String label;
  final bool showLabel;
  final bool isOptional;
  final String hintText;
  final double? borderWidth;
  final Color? enabledBorderColor;
  final String? suffixIcon;
  final Widget? customSuffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final double? labelGap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputAction textInputAction;
  final VoidCallback? onSuffixTap;
  final TextCapitalization? textCapitalization;
  final bool showMaxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final TextStyle? customStyle;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool? readOnly;
  final bool isEmail;
  final int maxLines;
  final bool autocorrect;
  final Widget? customLabel;
  final EdgeInsetsGeometry? contentPadding;
  final GlobalKey<FormState>? formKey;

  const CustomTextFieldWithLabel({
    super.key,
    required this.label,
    required this.hintText,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.isOptional = false,
    this.labelStyle,
    this.hintStyle,
    this.focusNode,
    this.labelGap,
    this.validator,
    this.inputFormatters,
    this.maxLength,
    this.textInputAction = TextInputAction.next,
    this.onSuffixTap,
    this.textCapitalization,
    this.showMaxLength = false,
    this.enabled = true,
    this.isEmail = false,
    this.readOnly = false,
    this.customSuffixIcon,
    this.showLabel = true,
    this.onTap,
    this.maxLines = 1,
    this.customStyle,
    this.autofocus = false,
    this.autocorrect = true,
    this.contentPadding,
    this.customLabel,
    this.formKey,
    this.borderWidth,
    this.enabledBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        final hasError = field.hasError;
        final isFocused = FocusScope.of(context).hasFocus;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showLabel)
              customLabel ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: (labelStyle ?? AppTextStyles.p1),
                      ),
                      isOptional
                          ? Text(
                              '(optional)',
                              style: AppTextStyles.p1,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
            if (showLabel) SizedBox(height: labelGap ?? 8),
            TextFormField(
              controller: enabled ? controller : null,
              autocorrect: autocorrect,
              inputFormatters: inputFormatters,
              focusNode: focusNode,
              autofocus: autofocus,
              readOnly: readOnly ?? false,
              enabled: enabled,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              maxLength: maxLength,
              obscureText: obscureText,
              maxLines: obscureText ? 1 : maxLines,
              onChanged: (value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged!(value);
                }
                formKey?.currentState?.validate();
              },
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onTap: onTap,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).unfocus();
              },
              style: customStyle ?? AppTextStyles.p2Light,
              decoration: InputDecoration(
                errorText: null,
                errorStyle: const TextStyle(fontSize: 0, height: 0),
                isDense: true,
                fillColor: AppColors.white,
                filled: true,
                border: inputBorder(
                  color: hasError
                      ? AppColors.errorDefault
                      : isFocused
                          ? AppColors.primaryDefault
                          : AppColors.grey500,
                ),
                counterText: !showMaxLength ? '' : null,
                suffixIcon: suffixIcon != null || customSuffixIcon != null
                    ? GestureDetector(
                        onTap: onSuffixTap,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          child: customSuffixIcon ??
                              SvgPicture.asset(
                                suffixIcon!,
                              ),
                        ),
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(),
                hintText: hintText,
                hintStyle: (hintStyle ?? AppTextStyles.p2Light),
                contentPadding: contentPadding ?? const EdgeInsets.all(15),
                focusedBorder: inputBorder(
                  color: AppColors.primaryDefault,
                ),
                enabledBorder: inputBorder(
                  color: hasError
                      ? AppColors.errorDefault
                      : enabledBorderColor ?? AppColors.grey500,
                ),
                errorBorder: inputBorder(
                  color: AppColors.errorDefault,
                ),
                focusedErrorBorder: inputBorder(
                  color: AppColors.errorDefault,
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: height(context, 0.002)),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(
                    color: AppColors.errorDefault,
                    fontSize:
                        12, // Increased from 10 to 12 for better visibility
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  InputBorder inputBorder({Color? color}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: color ?? AppColors.grey500,
          width: borderWidth ??
              1.5, // Slightly thicker border for better visibility
        ),
      );
}
