import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/plant_diagnosis.dart';
import '../../core/services/pdf_generator_service.dart';

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
  bool _isPdfGenerated = false;
  double _generationProgress = 0.0;
  String _currentStep = '';
  Uint8List? _generatedPdfData;
  
  // Informations de l'exploitation
  String _farmName = 'Mon Exploitation AgriShield';
  String _farmLocation = 'Région Centre, Burkina Faso';
  double _surfaceArea = 5.2;

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
      _isPdfGenerated = false;
      _generationProgress = 0.0;
      _currentStep = 'Préparation des données...';
    });

    _progressController.reset();
    _progressController.forward();

    // Simulation du processus de génération avec vraie génération PDF
    final steps = [
      'Préparation des données...',
      'Analyse des diagnostics IA...',
      'Génération de la heatmap...',
      'Compilation des recommandations...',
      'Création du document PDF stylisé...',
      'Application de la signature numérique...',
      'Optimisation et compression...',
      'Finalisation du rapport...',
    ];

    try {
      for (int i = 0; i < steps.length; i++) {
        setState(() {
          _currentStep = steps[i];
          _generationProgress = (i + 1) / steps.length;
        });
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Générer le PDF à l'étape de création
        if (i == 4) {
          _generatedPdfData = await PdfGeneratorService.generateStylizedReport(
            farmName: _farmName,
            location: _farmLocation,
            surfaceArea: _surfaceArea,
            diagnoses: widget.diagnosis != null ? [widget.diagnosis!] : null,
          );
        }
      }

      setState(() {
        _isGenerating = false;
        _isPdfGenerated = true;
      });

      // Afficher le succès avec options avancées
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });
      _showErrorDialog(e.toString());
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
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _previewPdf();
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('Aperçu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _shareReport();
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Partager'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shareReport() async {
    if (_generatedPdfData != null) {
      try {
        await Printing.sharePdf(
          bytes: _generatedPdfData!,
          filename: 'rapport_agrishield_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du partage: $e'),
            backgroundColor: AppColors.statusCritical,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez d\'abord générer le rapport'),
          backgroundColor: AppColors.statusWarning,
        ),
      );
    }
  }

  void _previewPdf() async {
    if (_generatedPdfData != null) {
      try {
        await Printing.layoutPdf(
          onLayout: (format) async => _generatedPdfData!,
          name: 'Aperçu Rapport AgriShield',
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'aperçu: $e'),
            backgroundColor: AppColors.statusCritical,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez d\'abord générer le rapport'),
          backgroundColor: AppColors.statusWarning,
        ),
      );
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error, color: AppColors.statusCritical),
            const SizedBox(width: 12),
            const Text('Erreur de génération'),
          ],
        ),
        content: Text('Une erreur s\'est produite lors de la génération du PDF:\n\n$error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
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

              // Personnalisation des informations
              _buildFarmInfoCustomization(),

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
    return Column(
      children: [
        // Bouton principal de génération
        Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryGreen,
                AppColors.primaryGreenDark,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _generateReport,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.picture_as_pdf, size: 24),
            ),
            label: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Générer le rapport PDF',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Version professionnelle certifiée IA',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Boutons d'actions rapides
        if (_isPdfGenerated) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _previewPdf,
                  icon: const Icon(Icons.visibility),
                  label: const Text('Aperçu'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentGold,
                    side: BorderSide(color: AppColors.accentGold),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _shareReport,
                  icon: const Icon(Icons.share),
                  label: const Text('Partager'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ).animate(controller: _animationController)
     .fadeIn(
       delay: const Duration(milliseconds: 1200),
       duration: const Duration(milliseconds: 600),
     )
     .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
  }

  Widget _buildFarmInfoCustomization() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreenLight.withOpacity(0.1),
            AppColors.accentGold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Personnaliser les informations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _buildCustomField(
            'Nom de l\'exploitation',
            _farmName,
            Icons.agriculture,
            (value) => setState(() => _farmName = value),
          ),
          
          const SizedBox(width: 16),
          
          _buildCustomField(
            'Localisation',
            _farmLocation,
            Icons.location_on,
            (value) => setState(() => _farmLocation = value),
          ),
          
          const SizedBox(width: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildSurfaceField(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.statusHealthy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.statusHealthy.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.verified_user, color: AppColors.statusHealthy, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        'Certification IA',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.statusHealthy,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(controller: _animationController)
     .fadeIn(delay: const Duration(milliseconds: 800))
     .slideY(begin: 0.3, end: 0);
  }

  Widget _buildCustomField(String label, String value, IconData icon, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurfaceField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.straighten, size: 16, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text(
                'Surface (hectares)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  if (_surfaceArea > 0.1) _surfaceArea -= 0.1;
                }),
                icon: const Icon(Icons.remove_circle),
                color: AppColors.statusWarning,
                iconSize: 32,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '${_surfaceArea.toStringAsFixed(1)} ha',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _surfaceArea += 0.1),
                icon: const Icon(Icons.add_circle),
                color: AppColors.statusHealthy,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
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
