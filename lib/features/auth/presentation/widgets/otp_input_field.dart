import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// * OTP INPUT FIELD WIDGET
// * Single digit input field for OTP verification
// * Features: Auto-focus, backspace handling, Material Design 3 styling

class OtpInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onBackspacePressed;

  const OtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspacePressed,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  
  bool _isFocused = false;
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupListeners();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // * Setup animations
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  // * Setup listeners
  void _setupListeners() {
    widget.focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onTextChanged);
  }

  // * Handle focus changes
  void _onFocusChanged() {
    final hasFocus = widget.focusNode.hasFocus;
    if (hasFocus != _isFocused) {
      setState(() {
        _isFocused = hasFocus;
      });

      if (hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  // * Handle text changes
  void _onTextChanged() {
    final hasValue = widget.controller.text.isNotEmpty;
    if (hasValue != _hasValue) {
      setState(() {
        _hasValue = hasValue;
      });
    }
  }

  // * Handle key events (for backspace detection)
  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        widget.controller.text.isEmpty) {
      widget.onBackspacePressed();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isFocused
                    ? colorScheme.primary
                    : (_hasValue
                        ? colorScheme.primary.withOpacity(0.5)
                        : colorScheme.outline.withOpacity(0.5)),
                width: _isFocused ? 2 : 1,
              ),
            ),
            child: Focus(
              onKeyEvent: (node, event) {
                return _handleKeyEvent(event) 
                    ? KeyEventResult.handled 
                    : KeyEventResult.ignored;
              },
              child: TextFormField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  // * Ensure only single digit
                  if (value.length > 1) {
                    value = value.substring(value.length - 1);
                    widget.controller.text = value;
                    widget.controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: value.length),
                    );
                  }
                  widget.onChanged(value);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// * ANIMATED OTP INPUT FIELD
// * Enhanced OTP field with additional animations

class AnimatedOtpInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onBackspacePressed;
  final bool hasError;

  const AnimatedOtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspacePressed,
    this.hasError = false,
  });

  @override
  State<AnimatedOtpInputField> createState() => _AnimatedOtpInputFieldState();
}

class _AnimatedOtpInputFieldState extends State<AnimatedOtpInputField>
    with TickerProviderStateMixin {
  late AnimationController _focusAnimationController;
  late AnimationController _errorAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  
  bool _isFocused = false;
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupListeners();
  }

  @override
  void dispose() {
    _focusAnimationController.dispose();
    _errorAnimationController.dispose();
    super.dispose();
  }

  // * Setup animations
  void _setupAnimations() {
    _focusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _errorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _focusAnimationController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _errorAnimationController,
      curve: Curves.elasticIn,
    ));
  }

  // * Setup listeners
  void _setupListeners() {
    widget.focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onTextChanged);
  }

  // * Handle focus changes
  void _onFocusChanged() {
    final hasFocus = widget.focusNode.hasFocus;
    if (hasFocus != _isFocused) {
      setState(() {
        _isFocused = hasFocus;
      });

      if (hasFocus) {
        _focusAnimationController.forward();
      } else {
        _focusAnimationController.reverse();
      }
    }
  }

  // * Handle text changes
  void _onTextChanged() {
    final hasValue = widget.controller.text.isNotEmpty;
    if (hasValue != _hasValue) {
      setState(() {
        _hasValue = hasValue;
      });
    }
  }

  // * Trigger error animation
  void _triggerErrorAnimation() {
    _errorAnimationController.forward().then((_) {
      _errorAnimationController.reverse();
    });
  }

  @override
  void didUpdateWidget(AnimatedOtpInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // * Trigger error animation when hasError changes to true
    if (widget.hasError && !oldWidget.hasError) {
      _triggerErrorAnimation();
    }
  }

  // * Handle key events (for backspace detection)
  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        widget.controller.text.isEmpty) {
      widget.onBackspacePressed();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _focusAnimationController,
        _errorAnimationController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset(
              _shakeAnimation.value * 10 * (0.5 - _shakeAnimation.value).sign,
              0,
            ),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: _isFocused
                    ? colorScheme.primary.withOpacity(0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.hasError
                      ? colorScheme.error
                      : (_isFocused
                          ? colorScheme.primary
                          : (_hasValue
                              ? colorScheme.primary.withOpacity(0.5)
                              : colorScheme.outline.withOpacity(0.5))),
                  width: _isFocused || widget.hasError ? 2 : 1,
                ),
              ),
              child: Focus(
                onKeyEvent: (node, event) {
                  return _handleKeyEvent(event) 
                      ? KeyEventResult.handled 
                      : KeyEventResult.ignored;
                },
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  style: textTheme.headlineMedium?.copyWith(
                    color: widget.hasError
                        ? colorScheme.error
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    // * Ensure only single digit
                    if (value.length > 1) {
                      value = value.substring(value.length - 1);
                      widget.controller.text = value;
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: value.length),
                      );
                    }
                    widget.onChanged(value);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 