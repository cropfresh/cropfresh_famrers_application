import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// * CUSTOM TEXT FIELD WIDGET
// * Material Design 3 compliant text field with enhanced features
// * Features: Accessibility, validation, custom styling, input formatters

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final Color? fillColor;
  final bool filled;

  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.fillColor,
    this.filled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFocused = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setupFocusListener();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // * Setup animation for focus states
  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  // * Setup focus listener for animations
  void _setupFocusListener() {
    widget.focusNode?.addListener(() {
      if (widget.focusNode?.hasFocus != _isFocused) {
        setState(() {
          _isFocused = widget.focusNode?.hasFocus ?? false;
        });

        if (_isFocused) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // * Check if error state changed
    final hasError = widget.errorText != null;
    if (hasError != _hasError) {
      setState(() {
        _hasError = hasError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // * Main Text Field
            TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              obscureText: widget.obscureText,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              textCapitalization: widget.textCapitalization,
              textAlign: widget.textAlign,
              style: textTheme.bodyLarge?.copyWith(
                color: widget.enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                helperText: widget.helperText,
                errorText: widget.errorText,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
                
                // * Content Padding
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                
                // * Fill and Colors
                filled: widget.filled,
                fillColor: widget.fillColor ??
                    (widget.enabled
                        ? colorScheme.surfaceVariant.withOpacity(0.3)
                        : colorScheme.surfaceVariant.withOpacity(0.1)),
                
                // * Label Style
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                floatingLabelStyle: textTheme.bodySmall?.copyWith(
                  color: _hasError
                      ? colorScheme.error
                      : (_isFocused
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant),
                  fontWeight: FontWeight.w600,
                ),
                
                // * Hint Style
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
                
                // * Helper Text Style
                helperStyle: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                
                // * Error Style
                errorStyle: textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
                
                // * Borders
                border: widget.border ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                
                focusedBorder: widget.focusedBorder ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                
                errorBorder: widget.errorBorder ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 1,
                      ),
                    ),
                
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 2,
                  ),
                ),
                
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                
                // * Counter Style
                counterStyle: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// * SPECIALIZED TEXT FIELD VARIANTS
// * Pre-configured text fields for common use cases

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool autofocus;

  const EmailTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: 'Email Address',
      hintText: 'Enter your email',
      prefixIcon: const Icon(Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool autofocus;

  const PasswordTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      labelText: widget.labelText ?? 'Password',
      hintText: 'Enter your password',
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        onPressed: _toggleVisibility,
        icon: Icon(
          _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
      obscureText: _isObscured,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
    );
  }
} 