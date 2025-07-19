import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/producer_profile_model.dart';

class ProductionCardWidget extends StatelessWidget {
  final Production production;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ProductionCardWidget({
    super.key,
    required this.production,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo de la production
                _buildProductionPhoto(),
                
                // Contenu de la carte
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header avec nom et statut
                      _buildHeader(context),
                      
                      const SizedBox(height: 12),
                      
                      // Informations détaillées
                      _buildDetails(context),
                      
                      // Actions
                      if (onDelete != null) ...[
                        const SizedBox(height: 12),
                        _buildActions(context),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductionPhoto() {
    if (production.photos.isNotEmpty) {
      return Container(
        height: 120,
        width: double.infinity,
        child: Stack(
          children: [
            Image.file(
              File(production.photos.first),
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultPhoto();
              },
            ),
            
            // Badge du statut
            Positioned(
              top: 8,
              right: 8,
              child: _buildStatusBadge(),
            ),
            
            // Overlay avec nombre de photos
            if (production.photos.length > 1)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${production.photos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }
    
    return _buildDefaultPhoto();
  }

  Widget _buildDefaultPhoto() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withOpacity(0.2),
            AppColors.primaryGreen.withOpacity(0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  production.status.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 4),
                Text(
                  'Aucune photo',
                  style: TextStyle(
                    color: AppColors.primaryGreen.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Badge du statut
          Positioned(
            top: 8,
            right: 8,
            child: _buildStatusBadge(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    switch (production.status) {
      case ProductionStatus.planned:
        badgeColor = AppColors.statusWarning;
        break;
      case ProductionStatus.active:
        badgeColor = AppColors.statusHealthy;
        break;
      case ProductionStatus.harvested:
        badgeColor = AppColors.accentGold;
        break;
      case ProductionStatus.archived:
        badgeColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        production.status.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            production.status.icon,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                production.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (production.season?.isNotEmpty == true)
                Text(
                  production.season!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    final List<Widget> details = [];

    // Date de plantation
    if (production.plantingDate != null) {
      details.add(
        _buildDetailRow(
          icon: Icons.event_available,
          label: 'Plantation',
          value: DateFormat('dd/MM/yyyy').format(production.plantingDate!),
        ),
      );
    }

    // Date de récolte
    if (production.harvestDate != null) {
      details.add(
        _buildDetailRow(
          icon: Icons.agriculture,
          label: 'Récolte',
          value: DateFormat('dd/MM/yyyy').format(production.harvestDate!),
        ),
      );
    }

    // Rendement estimé
    if (production.estimatedYield != null) {
      final unit = production.yieldUnit ?? 'kg';
      details.add(
        _buildDetailRow(
          icon: Icons.straighten,
          label: 'Rendement',
          value: '${production.estimatedYield!.toStringAsFixed(1)} $unit',
        ),
      );
    }

    // Notes
    if (production.notes?.isNotEmpty == true) {
      details.add(
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            production.notes!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    if (details.isEmpty) {
      return Text(
        'Aucune information détaillée',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details,
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: onTap,
            icon: const Icon(
              Icons.edit,
              size: 16,
            ),
            label: const Text('Modifier'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_outline,
            size: 16,
          ),
          label: const Text('Supprimer'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.statusDanger,
          ),
        ),
      ],
    );
  }
}