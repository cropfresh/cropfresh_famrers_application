// ===================================================================
// * CUSTOM APP BAR WIDGET
// * Purpose: Provides consistent app bar design across the application
// * Features: Title, back button, actions, search, customization
// ===================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool showSearchIcon;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showSearchIcon = false,
    this.onSearchPressed,
    this.onNotificationPressed,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: foregroundColor ?? theme.colorScheme.onSurface,
        ),
      ),
      leading: leading ?? (automaticallyImplyLeading ? _buildLeading(context) : null),
      actions: _buildActions(context),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: theme.appBarTheme.systemOverlayStyle,
      bottom: bottom,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      return IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
        tooltip: 'Back',
      );
    }
    return null;
  }

  List<Widget> _buildActions(BuildContext context) {
    final actionsList = <Widget>[];

    // * Add search icon if enabled
    if (showSearchIcon) {
      actionsList.add(
        IconButton(
          onPressed: onSearchPressed,
          icon: const Icon(Icons.search),
          tooltip: 'Search',
        ),
      );
    }

    // * Add notification icon if callback provided
    if (onNotificationPressed != null) {
      actionsList.add(
        IconButton(
          onPressed: onNotificationPressed,
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
        ),
      );
    }

    // * Add custom actions
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    return actionsList;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

// * Search App Bar variant
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClearPressed;
  final bool autofocus;
  final TextEditingController? controller;

  const SearchAppBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClearPressed,
    this.autofocus = true,
    this.controller,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _onClearPressed() {
    _controller.clear();
    widget.onClearPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      title: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
        onSubmitted: widget.onSubmitted,
      ),
      actions: [
        if (_hasText)
          IconButton(
            onPressed: _onClearPressed,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
          ),
      ],
    );
  }
}

// * Profile App Bar with avatar
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final VoidCallback? onAvatarTapped;
  final List<Widget>? actions;

  const ProfileAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarUrl,
    this.onAvatarTapped,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      title: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTapped,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 24,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// * Transparent App Bar for overlays
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;
  final Color iconColor;

  const TransparentAppBar({
    super.key,
    this.actions,
    this.leading,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: leading ?? IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: iconColor,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 