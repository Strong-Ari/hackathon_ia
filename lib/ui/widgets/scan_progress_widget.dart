import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../config.dart';
import '../../core/models/scan_result.dart';

// Widget d'affichage du progrès du scan
class ScanProgressWidget extends StatelessWidget {
  final ScanProgress progress;

  const ScanProgressWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Icône animée
            AnimatedBuilder(
              animation: progress.isScanning ? const AlwaysStoppedAnimation(1.0) : const AlwaysStoppedAnimation(0.0),
              builder: (context, child) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: progress.isScanning
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                          strokeWidth: 3,
                        )
                      : Icon(
                          progress.error != null ? Icons.error : Icons.check_circle,
                          color: progress.error != null ? AppTheme.errorColor : AppTheme.successColor,
                          size: 30,
                        ),
                );
              },
            ).animate()
              .scale(duration: const Duration(milliseconds: 300))
              .then()
              .shimmer(duration: const Duration(seconds: 2), delay: const Duration(seconds: 1)),

            const SizedBox(height: 20),

            // Texte de statut
            Text(
              progress.currentStep.isNotEmpty ? progress.currentStep : 'Analyse en cours...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: progress.error != null ? AppTheme.errorColor : AppTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Barre de progrès
            LinearProgressIndicator(
              value: progress.progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress.error != null ? AppTheme.errorColor : AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 12),

            // Pourcentage
            Text(
              '${(progress.progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Message d'erreur si applicable
            if (progress.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.errorColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        progress.error!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.2, end: 0, duration: const Duration(milliseconds: 300));
  }
}