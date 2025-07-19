import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/plant_diagnosis.dart';

class PdfReportPage extends StatefulWidget {
  final PlantDiagnosis? diagnosis;

  const PdfReportPage({super.key, this.diagnosis});

  @override
  State<PdfReportPage> createState() => _PdfReportPageState();
}

class _PdfReportPageState extends State<PdfReportPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _progressController;

  bool _isGenerating = false;
  double _generationProgress = 0.0;
  String _currentStep = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
      _generationProgress = 0.0;
      _currentStep = 'Préparation des données...';
    });

    _progressController.forward();

    // Simulation du processus de génération
    final steps = [
      'Préparation des données...',
      'Analyse des diagnostics...',
      'Génération de la heatmap...',
      'Compilation des recommandations...',
      'Création du document PDF...',
      'Signature numérique IA...',
      'Finalisation...',
    ];

    for (int i = 0; i < steps.length; i++) {
      setState(() {
        _currentStep = steps[i];
        _generationProgress = (i + 1) / steps.length;
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      _isGenerating = false;
    });

    // Afficher le succès
    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.statusHealthy.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.statusHealthy,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Rapport généré avec succès !',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Votre rapport PDF AgriShield a été créé et est prêt à être partagé.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pop();
                    },
                    child: const Text('Fermer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _shareReport();
                    },
                    child: const Text('Partager'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shareReport() {
    // Logique de partage du rapport
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ouverture de l\'application de partage...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapport PDF'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isGenerating ? null : () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header avec informations générales
              _buildReportHeader(),

              const SizedBox(height: 24),

              // Preview du contenu du rapport
              _buildReportPreview(),

              const SizedBox(height: 24),

              // Options de génération
              _buildGenerationOptions(),

              const SizedBox(height: 32),

              // Bouton de génération ou progress
              _isGenerating
                  ? _buildGenerationProgress()
                  : _buildGenerateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportHeader() {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rapport AgriShield AI',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Exploitation • ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildHeaderStat('12', 'Scans', Icons.camera_alt),
                  _buildHeaderStat('98%', 'Précision', Icons.verified),
                  _buildHeaderStat('5.2ha', 'Surface', Icons.landscape),
                ],
              ),
            ],
          ),
        )
        .animate(controller: _animationController)
        .fadeIn(duration: const Duration(milliseconds: 800))
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildReportPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contenu du rapport',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Sections du rapport
        _buildReportSection(
          'Informations de l\'exploitation',
          'Localisation, surface, type de cultures, historique',
          Icons.agriculture,
          AppColors.primaryGreen,
          0,
        ),

        _buildReportSection(
          'Diagnostics IA récents',
          'Analyses des 30 derniers jours avec niveaux de confiance',
          Icons.analytics,
          AppColors.accentGold,
          200,
        ),

        _buildReportSection(
          'Heatmap des maladies',
          'Cartographie visuelle des zones à risque',
          Icons.map,
          AppColors.statusWarning,
          400,
        ),

        _buildReportSection(
          'Recommandations personnalisées',
          'Actions prioritaires et traitements suggérés',
          Icons.lightbulb,
          AppColors.statusHealthy,
          600,
        ),

        _buildReportSection(
          'Tendances et prévisions',
          'Évolution de la santé des cultures sur 6 mois',
          Icons.trending_up,
          AppColors.primaryGreenLight,
          800,
        ),
      ],
    );
  }

  Widget _buildReportSection(
    String title,
    String description,
    IconData icon,
    Color color,
    int delay,
  ) {
    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle, color: color, size: 20),
            ],
          ),
        )
        .animate(controller: _animationController)
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 600),
        )
        .slideX(begin: 0.3, end: 0);
  }

  Widget _buildGenerationOptions() {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.backgroundBeige.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.security, color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Options de sécurité',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildOptionTile(
                'Signature numérique IA',
                'Authentification par intelligence artificielle',
                Icons.verified_user,
                true,
              ),

              _buildOptionTile(
                'Horodatage sécurisé',
                'Date et heure de génération certifiées',
                Icons.access_time,
                true,
              ),

              _buildOptionTile(
                'Géolocalisation',
                'Coordonnées GPS de l\'exploitation',
                Icons.location_on,
                true,
              ),

              _buildOptionTile(
                'Code de vérification',
                'QR code pour validation en ligne',
                Icons.qr_code,
                true,
              ),
            ],
          ),
        )
        .animate(controller: _animationController)
        .fadeIn(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 600),
        );
  }

  Widget _buildOptionTile(
    String title,
    String subtitle,
    IconData icon,
    bool enabled,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: enabled ? AppColors.statusHealthy : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            enabled ? Icons.check_circle : Icons.radio_button_unchecked,
            color: enabled ? AppColors.statusHealthy : AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _generateReport,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Générer le rapport PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        )
        .animate(controller: _animationController)
        .fadeIn(
          delay: const Duration(milliseconds: 1200),
          duration: const Duration(milliseconds: 600),
        )
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
  }

  Widget _buildGenerationProgress() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.autorenew,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Génération en cours...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentStep,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(_generationProgress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _generationProgress,
                backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
                borderRadius: BorderRadius.circular(4),
              );
            },
          ),

          const SizedBox(height: 16),

          Text(
            'Ne fermez pas l\'application pendant la génération',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
