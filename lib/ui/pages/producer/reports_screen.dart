import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config.dart';
import '../../../core/providers/sensor_provider.dart';
import '../../../core/providers/scan_provider.dart';
import '../../../core/services/api_service.dart';
import '../../widgets/report_card.dart';

// Écran de génération de rapports PDF
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _farmerNameController = TextEditingController();
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    // Valeurs par défaut pour les tests
    _farmNameController.text = 'Ferme AgriShield';
    _farmerNameController.text = 'Jean Dupont';
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _farmerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorData = ref.watch(realTimeSensorDataProvider);
    final scanHistory = ref.watch(scanHistoryProvider);
    final scanStats = ref.watch(scanStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports PDF'),
        actions: [
          IconButton(
            onPressed: () => context.go('/producer/reports/history'),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section de génération
            _buildGenerationSection(),
            const SizedBox(height: 30),

            // Statistiques
            _buildStatsSection(sensorData, scanStats),
            const SizedBox(height: 30),

            // Aperçu du rapport
            _buildPreviewSection(sensorData, scanHistory),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildGenerationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Générer un rapport',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Créez un rapport PDF détaillé de votre exploitation agricole',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              // Champs de saisie
              TextFormField(
                controller: _farmNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'exploitation',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom de l\'exploitation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _farmerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du producteur',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom du producteur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Bouton de génération
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generateReport,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(_isGenerating ? 'Génération...' : 'Générer le rapport'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(AsyncValue<List<dynamic>> sensorData, Map<String, dynamic> scanStats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Données disponibles',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: ReportCard(
                title: 'Capteurs',
                value: sensorData.when(
                  data: (sensors) => sensors.length.toString(),
                  loading: () => '...',
                  error: (_, __) => '0',
                ),
                icon: Icons.sensors,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ReportCard(
                title: 'Scans IA',
                value: scanStats['totalScans'].toString(),
                icon: Icons.camera_alt,
                color: AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewSection(AsyncValue<List<dynamic>> sensorData, List<dynamic> scanHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aperçu du rapport',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPreviewItem(
                  'Informations générales',
                  'Nom de l\'exploitation: ${_farmNameController.text}',
                  Icons.business,
                ),
                _buildPreviewItem(
                  'Producteur',
                  'Nom: ${_farmerNameController.text}',
                  Icons.person,
                ),
                _buildPreviewItem(
                  'Capteurs',
                  sensorData.when(
                    data: (sensors) => '${sensors.length} capteurs actifs',
                    loading: () => 'Chargement...',
                    error: (_, __) => 'Aucun capteur disponible',
                  ),
                  Icons.sensors,
                ),
                _buildPreviewItem(
                  'Scans IA',
                  '${scanHistory.length} analyses effectuées',
                  Icons.camera_alt,
                ),
                _buildPreviewItem(
                  'Date de génération',
                  DateTime.now().toString().substring(0, 16),
                  Icons.access_time,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/producer');
            break;
          case 1:
            context.go('/producer/scan');
            break;
          case 2:
            // Déjà sur les rapports
            break;
          case 3:
            context.go('/producer/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Tableau de bord',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Scan IA',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Rapports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
    );
  }

  Future<void> _generateReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final sensorData = ref.read(realTimeSensorDataProvider).value ?? [];
      final scanHistory = ref.read(scanHistoryProvider);
      final apiService = ref.read(scanApiServiceProvider);

      final pdfUrl = await apiService.generateReport(
        sensorData: sensorData.cast(),
        scanResults: scanHistory,
        farmName: _farmNameController.text,
        farmerName: _farmerNameController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rapport généré avec succès !'),
            backgroundColor: AppTheme.successColor,
            action: SnackBarAction(
              label: 'Télécharger',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Ouvrir le PDF
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la génération: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }
}