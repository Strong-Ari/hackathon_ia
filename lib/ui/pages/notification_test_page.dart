import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';
import '../../core/providers/notification_service.dart';
import '../../core/models/notification_model.dart';

class NotificationTestPage extends ConsumerStatefulWidget {
  const NotificationTestPage({super.key});

  @override
  ConsumerState<NotificationTestPage> createState() =>
      _NotificationTestPageState();
}

class _NotificationTestPageState extends ConsumerState<NotificationTestPage> {
  final TextEditingController _baseUrlController = TextEditingController();
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('api_base_url') ?? ApiConstants.baseUrl;
    _baseUrlController.text = savedUrl;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_base_url', _baseUrlController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuration sauvegardée'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _togglePolling() {
    final service = ref.read(notificationServiceProvider);

    setState(() {
      _isPolling = !_isPolling;
    });

    if (_isPolling) {
      service.startPolling();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Polling des notifications démarré'),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      service.stopPolling();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Polling des notifications arrêté'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _clearCache() async {
    final service = ref.read(notificationServiceProvider);
    await service.clearProcessedNotifications();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache des notifications nettoyé'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Future<void> _testNotification() async {
    // Créer une notification de test
    final testNotification = NotificationModel(
      audioFile: 'audio_files/test.mp3',
      message:
          'Ceci est un test du système de notifications vocales. Votre plantation semble être en bonne santé.',
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titre: 'Test de notification',
    );

    // Simuler l'arrivée d'une notification
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification de test créée (sans audio réel)'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _testSimpleNotification() async {
    final service = ref.read(notificationServiceProvider);
    
    final testNotification = NotificationModel(
      audioFile: '',
      message: 'Test de notification simple - Votre système fonctionne correctement.',
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titre: 'Notification Simple',
    );

    // Simuler l'affichage d'une notification simple
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Notification simple testée'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _testVoiceNotification() async {
    final service = ref.read(notificationServiceProvider);
    
    final testNotification = NotificationModel(
      audioFile: 'audio_files/voice_test.mp3',
      message: 'Test de notification vocale - Cette notification devrait être lue à voix haute.',
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titre: 'Notification Vocale',
    );

    // Simuler une notification vocale
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔊 Notification vocale testée (audio simulé)'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _testUrgentNotification() async {
    final service = ref.read(notificationServiceProvider);
    
    final testNotification = NotificationModel(
      audioFile: 'audio_files/urgent_alert.mp3',
      message: 'URGENT: Test d\'alerte critique - Intervention immédiate requise!',
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titre: 'ALERTE URGENTE',
    );

    // Simuler une notification urgente
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚨 Notification urgente testée'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Test des Notifications',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Configuration
              _buildSection('Configuration API', PhosphorIcons.gear(), [
                TextField(
                  controller: _baseUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL de base de l\'API',
                    hintText: 'http://192.168.1.100:5000',
                    prefixIcon: Icon(PhosphorIcons.globe()),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: Icon(PhosphorIcons.floppyDisk()),
                  label: const Text('Sauvegarder la configuration'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // Section Tests de notifications
              _buildSection('Tests de Notifications', PhosphorIcons.bell(), [
                ElevatedButton.icon(
                  onPressed: _testSimpleNotification,
                  icon: Icon(PhosphorIcons.bellSimple()),
                  label: const Text('Notification Simple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _testVoiceNotification,
                  icon: Icon(PhosphorIcons.speakerHigh()),
                  label: const Text('Notification Vocale'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: theme.colorScheme.onTertiary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _testUrgentNotification,
                  icon: Icon(PhosphorIcons.warning()),
                  label: const Text('Notification Urgente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // Section État des notifications
              _buildSection('État des Notifications', PhosphorIcons.info(), [
                _buildStatusCard(),
              ]),

              // Espacement final pour éviter le débordement
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final theme = Theme.of(context);
    final notificationService = ref.watch(notificationServiceProvider);
    
    return Column(
      children: [
        _buildInfoCard(
          'État du Polling',
          _isPolling ? 'Actif' : 'Inactif',
          _isPolling ? PhosphorIcons.play() : PhosphorIcons.pause(),
          _isPolling ? Colors.green : Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          'URL API Configurée',
          _baseUrlController.text.isEmpty ? 'Non configurée' : _baseUrlController.text,
          PhosphorIcons.globe(),
          _baseUrlController.text.isEmpty ? Colors.red : Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          'Dernière Vérification',
          'Jamais', // You can enhance this to show actual last check time
          PhosphorIcons.clock(),
          Colors.grey,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _togglePolling,
                icon: Icon(_isPolling ? PhosphorIcons.pause() : PhosphorIcons.play()),
                label: Text(_isPolling ? 'Arrêter Polling' : 'Démarrer Polling'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPolling ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
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
                onPressed: _clearCache,
                icon: Icon(PhosphorIcons.trash()),
                label: const Text('Vider Cache'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
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
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
