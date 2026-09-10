import 'package:flutter/material.dart';

/// Renders a standardized section header title for settings groups.
Widget buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      letterSpacing: 1.1,
    ),
  );
}

/// Container wrapper grouping multiple settings tiles with theme-aware styling and soft shadows.
Widget buildSettingsCard(BuildContext context, List<Widget> children) {
  return Material(
    color: (Theme.of(context).cardTheme.color ?? Colors.white).withValues(
      alpha: 0.9,
    ),
    borderRadius: BorderRadius.circular(16),
    clipBehavior: Clip.antiAlias, // Ensures ink splash respects rounded borders
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    ),
  );
}

/// Renders a standard interactive settings list tile with icon, title, subtitle, and trailing arrow indicator.
Widget buildListTile({
  required BuildContext context,
  required String title,
  required String subtitle,
  required IconData icon,
  VoidCallback? onTap,
}) {
  return ListTile(
    onTap: onTap,
    leading: Icon(icon, color: const Color(0xFF0F52BA)),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    ),
    trailing: onTap != null
        ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
        : null,
  );
}
