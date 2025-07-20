import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/notification_model.dart';
import '../../core/providers/notification_history_service.dart';

class NotificationHistoryPanel extends ConsumerStatefulWidget {
  const NotificationHistoryPanel({super.key});

  @override
  ConsumerState<NotificationHistoryPanel> createState() => NotificationHistoryPanelState();
}

// Exposer la classe State pour permettre l'accès aux méthodes publiques
class NotificationHistoryPanelState extends ConsumerState<NotificationHistoryPanel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void togglePanel() {
    setState(() {
      _isVisible = !_isVisible;
    });
    
    if (_isVisible) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
  }

  void closePanel() {
    setState(() {
      _isVisible = false;
    });
    _slideController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Overlay sombre
        if (_isVisible)
          GestureDetector(
            onTap: closePanel,
            child: Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
            ),
          ).animate().fadeIn(duration: 300.ms),

        // Panel latéral
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _slideController,
              curve: Curves.easeInOut,
            )),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 10,
                    offset: Offset(-2, 0),
                  ),
                ],
              ),
              child: _buildPanelContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPanelContent() {
    return SafeArea(
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Liste des notifications
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.history,
            color: AppColors.textOnDark,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Historique des notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: closePanel,
            icon: const Icon(
              Icons.close,
              color: AppColors.textOnDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    final historyAsync = ref.watch(notificationHistoryProvider);
    
    return historyAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return _buildEmptyState();
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(notificationHistoryServiceProvider).refreshHistory();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(notification, index);
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreen,
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification, int index) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(notification.timestamp * 1000);
    final formattedDate = DateFormat('dd/MM/yyyy à HH:mm').format(dateTime);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showNotificationDetails(notification),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header avec titre et icône audio
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.notifications_active,
                          color: AppColors.primaryGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          notification.titre,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _playAudio(notification),
                        icon: const Icon(
                          Icons.volume_up,
                          color: AppColors.accentGold,
                        ),
                        tooltip: 'Écouter la notification',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Message
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: notification.imagePath != null ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Image si disponible
                  if (notification.imagePath != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          notification.imagePath!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: AppColors.primaryGreen,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.textSecondary.withOpacity(0.1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    color: AppColors.textSecondary.withOpacity(0.5),
                                    size: 32,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Image non disponible',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 8),
                  
                  // Date et heure
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 50))
     .slideX(begin: 0.3, end: 0, duration: 300.ms)
     .fadeIn(duration: 300.ms);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos notifications apparaîtront ici',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.statusDanger,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _playAudio(NotificationModel notification) {
    ref.read(notificationHistoryServiceProvider).playNotificationAudio(notification);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.volume_up, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Lecture: ${notification.titre}'),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showNotificationDetails(NotificationModel notification) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(notification.timestamp * 1000);
    final formattedDate = DateFormat('dd/MM/yyyy à HH:mm:ss').format(dateTime);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                notification.titre,
                style: const TextStyle(color: AppColors.primaryGreen),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Message:',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 16),
            Text(
              'Reçu le:',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(formattedDate),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _playAudio(notification);
            },
            icon: const Icon(Icons.volume_up),
            label: const Text('Écouter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}