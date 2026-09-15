import 'package:flutter/material.dart';
import '../config/admin_colors.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final Function()? onLeadingPressed;

  const AdminAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showLeading = true,
    this.onLeadingPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AdminColors.onSurface,
        ),
      ),
      backgroundColor: AdminColors.surfaceContainerLowest,
      elevation: 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: AdminColors.primary,
      centerTitle: false,
      leading: showLeading
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AdminColors.onSurface),
              onPressed: onLeadingPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: actions,
      border: Border(
        bottom: BorderSide(
          color: AdminColors.outlineVariant,
          width: 1,
        ),
      ),
    );
  }
}
