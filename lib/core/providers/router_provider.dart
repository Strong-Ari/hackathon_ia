import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/pages/splash_screen.dart';
import '../../ui/pages/home_screen.dart';
import '../../ui/pages/producer/producer_dashboard_screen.dart';
import '../../ui/pages/producer/scan_screen.dart';
import '../../ui/pages/producer/reports_screen.dart';
import '../../ui/pages/consumer/consumer_screen.dart';

// Provider pour la configuration du routeur
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Écran de splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Écran d'accueil
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Routes de l'espace producteur
      GoRoute(
        path: '/producer',
        name: 'producer',
        builder: (context, state) => const ProducerDashboardScreen(),
        routes: [
          GoRoute(
            path: 'scan',
            name: 'producer_scan',
            builder: (context, state) => const ScanScreen(),
            routes: [
              GoRoute(
                path: 'history',
                name: 'producer_scan_history',
                builder: (context, state) => const ScanHistoryScreen(),
              ),
              GoRoute(
                path: 'result/:id',
                name: 'producer_scan_result',
                builder: (context, state) {
                  final scanId = state.pathParameters['id']!;
                  return ScanResultScreen(scanId: scanId);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'reports',
            name: 'producer_reports',
            builder: (context, state) => const ReportsScreen(),
            routes: [
              GoRoute(
                path: 'history',
                name: 'producer_reports_history',
                builder: (context, state) => const ReportsHistoryScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'settings',
            name: 'producer_settings',
            builder: (context, state) => const ProducerSettingsScreen(),
          ),
        ],
      ),
      
      // Routes de l'espace consommateur
      GoRoute(
        path: '/consumer',
        name: 'consumer',
        builder: (context, state) => const ConsumerScreen(),
        routes: [
          GoRoute(
            path: 'scan',
            name: 'consumer_scan',
            builder: (context, state) => const ConsumerScanScreen(),
          ),
          GoRoute(
            path: 'search',
            name: 'consumer_search',
            builder: (context, state) => const ConsumerSearchScreen(),
          ),
          GoRoute(
            path: 'history',
            name: 'consumer_history',
            builder: (context, state) => const ConsumerHistoryScreen(),
          ),
          GoRoute(
            path: 'info',
            name: 'consumer_info',
            builder: (context, state) => const ConsumerInfoScreen(),
          ),
        ],
      ),
    ],
    
    // Gestion des erreurs 404
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page non trouvée'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La page que vous recherchez n\'existe pas.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
    
    // Transitions personnalisées
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: _buildPage(state),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    },
  );
});

// Fonction pour construire les pages
Widget _buildPage(GoRouterState state) {
  switch (state.matchedLocation) {
    case '/splash':
      return const SplashScreen();
    case '/home':
      return const HomeScreen();
    case '/producer':
      return const ProducerDashboardScreen();
    case '/producer/scan':
      return const ScanScreen();
    case '/producer/reports':
      return const ReportsScreen();
    case '/consumer':
      return const ConsumerScreen();
    default:
      return const Scaffold(
        body: Center(
          child: Text('Page en cours de développement'),
        ),
      );
  }
}

// Écrans temporaires pour les routes non encore implémentées
class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des scans')),
      body: const Center(
        child: Text('Historique des scans - En cours de développement'),
      ),
    );
  }
}

class ScanResultScreen extends StatelessWidget {
  final String scanId;
  
  const ScanResultScreen({super.key, required this.scanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Résultat scan $scanId')),
      body: const Center(
        child: Text('Détails du scan - En cours de développement'),
      ),
    );
  }
}

class ReportsHistoryScreen extends StatelessWidget {
  const ReportsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des rapports')),
      body: const Center(
        child: Text('Historique des rapports - En cours de développement'),
      ),
    );
  }
}

class ProducerSettingsScreen extends StatelessWidget {
  const ProducerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: const Center(
        child: Text('Paramètres producteur - En cours de développement'),
      ),
    );
  }
}

class ConsumerScanScreen extends StatelessWidget {
  const ConsumerScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner un produit')),
      body: const Center(
        child: Text('Scanner produit - En cours de développement'),
      ),
    );
  }
}

class ConsumerSearchScreen extends StatelessWidget {
  const ConsumerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher un producteur')),
      body: const Center(
        child: Text('Recherche producteur - En cours de développement'),
      ),
    );
  }
}

class ConsumerHistoryScreen extends StatelessWidget {
  const ConsumerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: const Center(
        child: Text('Historique consommateur - En cours de développement'),
      ),
    );
  }
}

class ConsumerInfoScreen extends StatelessWidget {
  const ConsumerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('En savoir plus')),
      body: const Center(
        child: Text('Informations - En cours de développement'),
      ),
    );
  }
}
