import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../config.dart';

// Enum pour les tendances
enum Trend { up, down, stable }

// Widget de carte pour le tableau de bord
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Trend trend;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend = Trend.stable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec icône et tendance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  _buildTrendIndicator(),
                ],
              ),
              
              const Spacer(),
              
              // Valeur principale
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Titre
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.2, end: 0, duration: const Duration(milliseconds: 300));
  }

  Widget _buildTrendIndicator() {
    IconData icon;
    Color color;
    String tooltip;

    switch (trend) {
      case Trend.up:
        icon = Icons.trending_up;
        color = AppTheme.successColor;
        tooltip = 'En hausse';
        break;
      case Trend.down:
        icon = Icons.trending_down;
        color = AppTheme.errorColor;
        tooltip = 'En baisse';
        break;
      case Trend.stable:
        icon = Icons.trending_flat;
        color = Colors.grey;
        tooltip = 'Stable';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }
}