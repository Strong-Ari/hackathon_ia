import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../config.dart';
import '../../core/models/scan_result.dart';

// Widget de carte de résultat de scan
class ScanResultCard extends StatelessWidget {
  final ScanResult result;
  final bool compact;
  final VoidCallback? onTap;

  const ScanResultCard({
    super.key,
    required this.result,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.cardRadius),
        child: Padding(
          padding: EdgeInsets.all(compact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec statut
              Row(
                children: [
                  // Icône de statut
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: result.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      result.isHealthy ? Icons.check_circle : Icons.warning,
                      color: result.statusColor,
                      size: 20,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Informations principales
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.plantName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!compact) ...[
                          const SizedBox(height: 4),
                          Text(
                            result.statusText,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: result.statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Confiance
                  if (!compact) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: result.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        result.confidence,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: result.statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              if (!compact) ...[
                const SizedBox(height: 16),
                
                // Diagnostic
                Text(
                  'Diagnostic',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result.diagnosis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                // Maladies détectées
                if (result.diseases.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Maladies détectées',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: result.diseases.map((disease) => Chip(
                      label: Text(
                        disease,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppTheme.errorColor.withOpacity(0.1),
                      labelStyle: TextStyle(color: AppTheme.errorColor),
                    )).toList(),
                  ),
                ],

                // Recommandations
                if (result.recommendations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Recommandations',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...result.recommendations.take(3).map((recommendation) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppTheme.successColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recommendation,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],

                // Date et localisation
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(result.scanDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    if (result.location.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        result.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ] else ...[
                // Version compacte
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(result.scanDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      result.confidence,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: result.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.2, end: 0, duration: const Duration(milliseconds: 300));
  }
}