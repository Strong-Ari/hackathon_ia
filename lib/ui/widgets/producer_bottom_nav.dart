import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/notification_provider.dart';
import 'notification_badge.dart';

class ProducerBottomNav extends ConsumerWidget {
  final int currentIndex;

  const ProducerBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationHistoryProvider);
    final unreadCount = notifications.length;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.chartLineUp),
              activeIcon: Icon(PhosphorIcons.chartLineUpFill),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: NotificationBadge(
                count: unreadCount,
                child: const Icon(PhosphorIcons.bell),
              ),
              activeIcon: NotificationBadge(
                count: unreadCount,
                child: const Icon(PhosphorIcons.bellFill),
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.user),
              activeIcon: Icon(PhosphorIcons.userFill),
              label: 'Profil',
            ),
          ],
          onTap: (index) => _onItemTapped(context, index),
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go('/producer/dashboard');
        break;
      case 1:
        context.push('/notifications/history');
        break;
      case 2:
        context.push('/producer/profile');
        break;
    }
  }
}