import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config.dart';
import '../../../core/providers/scan_provider.dart';
import '../../widgets/scan_progress_widget.dart';
import '../../widgets/scan_result_card.dart';

// Écran de scan IA des plantes
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final scanProgress = ref.watch(scanProgressProvider);
    final lastScanResult = ref.watch(lastScanResultProvider);
    final scanHistory = ref.watch(scanHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan IA des plantes'),
        actions: [
          IconButton(
            onPressed: () => context.go('/producer/scan/history'),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section de scan
            _buildScanSection(),
            const SizedBox(height: 30),

            // Progrès du scan en cours
            if (scanProgress.isScanning) ...[
              ScanProgressWidget(progress: scanProgress),
              const SizedBox(height: 30),
            ],

            // Dernier résultat
            if (lastScanResult != null) ...[
              _buildLastResultSection(lastScanResult),
              const SizedBox(height: 30),
            ],

            // Historique récent
            if (scanHistory.isNotEmpty) ...[
              _buildHistorySection(scanHistory),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildScanSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scanner une plante',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Prenez une photo de votre plante pour obtenir un diagnostic IA instantané',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Appareil photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galerie'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastResultSection(ScanResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dernier scan',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ScanResultCard(
          result: result,
          onTap: () => context.go('/producer/scan/result/${result.id}'),
        ),
      ],
    );
  }

  Widget _buildHistorySection(List<ScanResult> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Historique récent',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/producer/scan/history'),
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...history.take(3).map((result) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ScanResultCard(
            result: result,
            compact: true,
            onTap: () => context.go('/producer/scan/result/${result.id}'),
          ),
        )),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/producer');
            break;
          case 1:
            // Déjà sur le scan
            break;
          case 2:
            context.go('/producer/reports');
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        
        // Déclencher le scan
        ref.read(currentScanProvider(file));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection d\'image: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}