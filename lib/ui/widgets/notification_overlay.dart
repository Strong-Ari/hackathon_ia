import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/notification_model.dart';
import '../../core/providers/notification_service.dart';
import 'voice_notification_card.dart';

class NotificationOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const NotificationOverlay({super.key, required this.child});

  @override
  ConsumerState<NotificationOverlay> createState() =>
      _NotificationOverlayState();
}

class _NotificationOverlayState extends ConsumerState<NotificationOverlay> {
  final List<NotificationModel> _activeNotifications = [];
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    // Démarrer le polling des notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).startPolling();
    });
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    ref.read(notificationServiceProvider).dispose();
    super.dispose();
  }

  void _addNotification(NotificationModel notification) {
    setState(() {
      _activeNotifications.add(notification);
    });

    // Auto-dismiss après 8 secondes
    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(const Duration(seconds: 8), () {
      _dismissNotification(notification);
    });
  }

  void _dismissNotification(NotificationModel notification) {
    setState(() {
      _activeNotifications.remove(notification);
    });
  }

  void _dismissAllNotifications() {
    setState(() {
      _activeNotifications.clear();
    });
    _autoDismissTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<NotificationModel?>>(notificationStreamProvider, (
      previous,
      next,
    ) {
      next.whenData((notification) {
        if (notification != null) {
          _addNotification(notification);
        }
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          // Contenu principal de l'application
          widget.child,

          // Overlay des notifications
          if (_activeNotifications.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Notifications actives
                    ..._activeNotifications.map((notification) {
                      return VoiceNotificationCard(
                        notification: notification,
                        onDismiss: () => _dismissNotification(notification),
                        onTap: () {
                          // Optionnel: action lors du tap sur la notification
                          _dismissNotification(notification);
                        },
                      );
                    }).toList(),

                    // Bouton pour tout dismisser si plusieurs notifications
                    if (_activeNotifications.length > 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _dismissAllNotifications,
                              child: Text(
                                'Tout effacer',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
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
}
