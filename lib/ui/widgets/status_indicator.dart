import 'package:flutter/material.dart';
import '../../config.dart';

// Enum pour les statuts
enum Status { healthy, warning, critical, offline }

// Widget d'indicateur de statut
class StatusIndicator extends StatelessWidget {
  final Status status;
  final double size;

  const StatusIndicator({
    super.key,
    required this.status,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getStatusColor(),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case Status.healthy:
        return AppTheme.successColor;
      case Status.warning:
        return AppTheme.warningColor;
      case Status.critical:
        return AppTheme.errorColor;
      case Status.offline:
        return Colors.grey;
    }
  }
}

// Widget d'indicateur de statut avec texte
class StatusIndicatorWithText extends StatelessWidget {
  final Status status;
  final String text;
  final double indicatorSize;

  const StatusIndicatorWithText({
    super.key,
    required this.status,
    required this.text,
    this.indicatorSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusIndicator(
          status: status,
          size: indicatorSize,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: _getStatusColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case Status.healthy:
        return AppTheme.successColor;
      case Status.warning:
        return AppTheme.warningColor;
      case Status.critical:
        return AppTheme.errorColor;
      case Status.offline:
        return Colors.grey;
    }
  }
}