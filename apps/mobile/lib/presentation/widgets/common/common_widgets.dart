import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';

/// Stat card widget for displaying metrics
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool? trendUp;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (trendUp == true
                              ? AppTheme.successColor
                              : AppTheme.errorColor)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendUp == true
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 14,
                          color: trendUp == true
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trend!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: trendUp == true
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.heading4,
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: DefaultTextStyle(
              style: AppTextStyles.bodySmall.copyWith(
                color: AppTheme.primaryColor,
              ),
              child: trailing!,
            ),
          ),
      ],
    );
  }
}

/// Loading button widget
class LoadingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : child,
      ),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.heading4.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Search bar widget
class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller?.text.isNotEmpty == true)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              ),
            if (onFilterTap != null)
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: onFilterTap,
              ),
          ],
        ),
      ),
    );
  }
}

/// Status badge widget
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor ?? color,
        ),
      ),
    );
  }
}

/// Confirmation dialog helper
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDangerous = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: isDangerous
              ? ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
