import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../config.dart';

// Widget de carte pour les rapports
class ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
            children: [
              // Icône
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Valeur
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Titre
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.2, end: 0, duration: const Duration(milliseconds: 300));
  }
}