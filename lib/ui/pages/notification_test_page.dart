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
