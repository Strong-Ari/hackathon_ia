import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/router_provider.dart';
import '../../core/models/plant_diagnosis.dart';
import '../widgets/agri_button.dart';

class DiagnosisPage extends StatefulWidget {
  final PlantDiagnosis? diagnosis;

  const DiagnosisPage({
    super.key,
    this.diagnosis,
  });

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage>
    with TickerProviderStateMixin {
  late AnimationController _contentController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _contentController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _progressController.forward();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  PlantDiagnosis get diagnosis => widget.diagnosis ?? _getDefaultDiagnosis();

  PlantDiagnosis _getDefaultDiagnosis() {
    return PlantDiagnosis(
      id: 'default',
      plantName: 'Plante inconnue',
      diseaseName: 'Aucune maladie détectée',
      diseaseType: DiseaseType.environmental,
      status: PlantHealthStatus.healthy,
      confidence: 0.95,
      estimatedLoss: 0.0,
      description: 'La plante semble en bonne santé.',
      symptoms: [],
      treatments: [],
      imagePath: '',
      timestamp: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: diagnosis.statusColor.withOpacity(0.05),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Diagnostic IA',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carte résultat principal
              _buildMainResultCard(),

              const SizedBox(height: AppDimensions.spaceLG),

              // Confidence et perte estimée
              _buildStatsRow(),

              const SizedBox(height: AppDimensions.spaceLG),

              // Détails de la maladie
              if (diagnosis.status != PlantHealthStatus.healthy) ...[
                _buildDiseaseDetailsCard(),
                const SizedBox(height: AppDimensions.spaceLG),
              ],

              // Symptômes détectés
              if (diagnosis.symptoms.isNotEmpty) ...[
                _buildSymptomsCard(),
                const SizedBox(height: AppDimensions.spaceLG),
              ],

              // Actions recommandées
              _buildActionsSection(),

              const SizedBox(height: AppDimensions.spaceXXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainResultCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: diagnosis.statusColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          children: [
            // Icône et statut
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: diagnosis.statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: diagnosis.statusColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                diagnosis.diseaseTypeIcon,
                size: 40,
                color: diagnosis.statusColor,
              ),
            )
                .animate(controller: _contentController)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: 600.ms,
                  delay: 200.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: AppDimensions.spaceLG),

            // Nom de la plante
            Text(
              diagnosis.plantName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            )
                .animate(controller: _contentController)
                .fadeIn(
                  duration: 600.ms,
                  delay: 400.ms,
                )
                .slideY(
                  begin: 0.3,
                  end: 0.0,
                  duration: 600.ms,
                  delay: 400.ms,
                ),

            const SizedBox(height: AppDimensions.spaceMD),

            // Statut
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLG,
                vertical: AppDimensions.paddingSM,
              ),
              decoration: BoxDecoration(
                color: diagnosis.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                border: Border.all(
                  color: diagnosis.statusColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                diagnosis.statusText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: diagnosis.statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                .animate(controller: _contentController)
                .fadeIn(
                  duration: 600.ms,
                  delay: 600.ms,
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 600.ms,
                  delay: 600.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: AppDimensions.spaceLG),

            // Maladie détectée
            if (diagnosis.status != PlantHealthStatus.healthy) ...[
              Text(
                'Maladie détectée:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXS),
              Text(
                diagnosis.diseaseName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: diagnosis.statusColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceMD),
              Text(
                diagnosis.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Text(
                'Excellente nouvelle ! 🎉',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: diagnosis.statusColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceMD),
              Text(
                'Votre plante est en parfaite santé. Continuez vos bonnes pratiques !',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    )
        .animate(controller: _contentController)
        .fadeIn(duration: 600.ms)
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        // Confiance IA
        Expanded(
          child: _buildStatCard(
            title: 'Confiance IA',
            value: '${(diagnosis.confidence * 100).toInt()}%',
            icon: Icons.psychology_outlined,
            color: AppColors.primaryGreen,
            progress: diagnosis.confidence,
          ),
        ),

        const SizedBox(width: AppDimensions.spaceMD),

        // Perte estimée
        Expanded(
          child: _buildStatCard(
            title: 'Perte estimée',
            value: '${diagnosis.estimatedLoss.toStringAsFixed(1)}%',
            icon: Icons.trending_down_outlined,
            color: diagnosis.estimatedLoss > 10
                ? AppColors.statusDanger
                : diagnosis.estimatedLoss > 5
                    ? AppColors.statusWarning
                    : AppColors.statusHealthy,
            progress: diagnosis.estimatedLoss / 100,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppDimensions.iconLG,
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          // Barre de progression
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: double.infinity,
                    child: FractionallySizedBox(
                      widthFactor: progress * _progressController.value,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    )
        .animate(controller: _contentController)
        .fadeIn(
          duration: 600.ms,
          delay: 800.ms,
        )
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          delay: 800.ms,
        );
  }

  Widget _buildDiseaseDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                diagnosis.diseaseTypeIcon,
                color: diagnosis.statusColor,
                size: AppDimensions.iconMD,
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Text(
                'Type: ${diagnosis.diseaseTypeText}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            diagnosis.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    )
        .animate(controller: _contentController)
        .fadeIn(
          duration: 600.ms,
          delay: 1000.ms,
        )
        .slideX(
          begin: -0.3,
          end: 0.0,
          duration: 600.ms,
          delay: 1000.ms,
        );
  }

  Widget _buildSymptomsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: AppColors.statusWarning,
                size: AppDimensions.iconMD,
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Text(
                'Symptômes détectés',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          ...diagnosis.symptoms.asMap().entries.map((entry) {
            final index = entry.key;
            final symptom = entry.value;

            return Container(
              margin: EdgeInsets.only(
                bottom: index < diagnosis.symptoms.length - 1
                    ? AppDimensions.marginSM
                    : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: AppDimensions.marginMD,
                    ),
                    decoration: BoxDecoration(
                      color: diagnosis.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      symptom,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    )
        .animate(controller: _contentController)
        .fadeIn(
          duration: 600.ms,
          delay: 1200.ms,
        )
        .slideX(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          delay: 1200.ms,
        );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions recommandées',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        )
            .animate(controller: _contentController)
            .fadeIn(
              duration: 600.ms,
              delay: 1400.ms,
            )
            .slideY(
              begin: 0.3,
              end: 0.0,
              duration: 600.ms,
              delay: 1400.ms,
            ),

        const SizedBox(height: AppDimensions.spaceLG),

        // Boutons d'action
        Row(
          children: [
            Expanded(
              child: AgriButton(
                text: 'Voir recommandations IA',
                type: AgriButtonType.primary,
                icon: Icons.auto_awesome,
                onPressed: () {
                  context.push(AppRoutes.actions, extra: diagnosis);
                },
              ),
            ),
          ],
        )
            .animate(controller: _contentController)
            .fadeIn(
              duration: 600.ms,
              delay: 1600.ms,
            )
            .slideY(
              begin: 0.3,
              end: 0.0,
              duration: 600.ms,
              delay: 1600.ms,
            ),

        const SizedBox(height: AppDimensions.spaceMD),

        Row(
          children: [
            Expanded(
              child: AgriButton(
                text: 'Nouvelle analyse',
                type: AgriButtonType.outlined,
                icon: Icons.camera_alt_outlined,
                onPressed: () {
                  context.pop();
                  context.push(AppRoutes.scan);
                },
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMD),
            Expanded(
              child: AgriButton(
                text: 'Historique',
                type: AgriButtonType.outlined,
                icon: Icons.history,
                onPressed: () {
                  context.push(AppRoutes.history);
                },
              ),
            ),
          ],
        )
            .animate(controller: _contentController)
            .fadeIn(
              duration: 600.ms,
              delay: 1800.ms,
            )
            .slideY(
              begin: 0.3,
              end: 0.0,
              duration: 600.ms,
              delay: 1800.ms,
            ),
      ],
    );
  }
}
