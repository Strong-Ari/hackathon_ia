import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config.dart';

// Enum pour les types d'alerte
enum AlertType { info, warning, error, success }

// Widget de bannière d'alerte
class AlertBanner extends StatelessWidget {
  final String message;
  final AlertType type;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionText;

  const AlertBanner({
    super.key,
    required this.message,
    this.type = AlertType.info,
    this.onDismiss,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppConfig.cardRadius),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icône
          Icon(
            _getIcon(),
            color: _getIconColor(),
            size: 24,
          ),
          
          const SizedBox(width: 12),
          
          // Message
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Bouton d'action (optionnel)
          if (onAction != null && actionText != null) ...[
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: _getIconColor(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
              ),
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          
          // Bouton de fermeture (optionnel)
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                color: _getIconColor(),
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideX(begin: -0.3, end: 0, duration: const Duration(milliseconds: 300));
  }

  IconData _getIcon() {
    switch (type) {
      case AlertType.info:
        return Icons.info_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _getBackgroundColor() {
    switch (type) {
      case AlertType.info:
        return AppTheme.infoColor.withOpacity(0.1);
      case AlertType.warning:
        return AppTheme.warningColor.withOpacity(0.1);
      case AlertType.error:
        return AppTheme.errorColor.withOpacity(0.1);
      case AlertType.success:
        return AppTheme.successColor.withOpacity(0.1);
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case AlertType.info:
        return AppTheme.infoColor.withOpacity(0.3);
      case AlertType.warning:
        return AppTheme.warningColor.withOpacity(0.3);
      case AlertType.error:
        return AppTheme.errorColor.withOpacity(0.3);
      case AlertType.success:
        return AppTheme.successColor.withOpacity(0.3);
    }
  }

  Color _getIconColor() {
    switch (type) {
      case AlertType.info:
        return AppTheme.infoColor;
      case AlertType.warning:
        return AppTheme.warningColor;
      case AlertType.error:
        return AppTheme.errorColor;
      case AlertType.success:
        return AppTheme.successColor;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case AlertType.info:
        return AppTheme.infoColor;
      case AlertType.warning:
        return AppTheme.warningColor;
      case AlertType.error:
        return AppTheme.errorColor;
      case AlertType.success:
        return AppTheme.successColor;
    }
  }
}