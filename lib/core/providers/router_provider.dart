import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/pages/splash_page.dart';
import '../../ui/pages/home_page.dart';
import '../../ui/pages/scan_page.dart';
import '../../ui/pages/diagnosis_page.dart';
import '../../ui/pages/actions_page.dart';
import '../../ui/pages/report_page.dart';
import '../../ui/pages/map_page.dart';
import '../../ui/pages/sentinel_page.dart';
import '../../ui/pages/history_page.dart';
import '../../ui/pages/producer_dashboard_page.dart';
import '../../ui/pages/pdf_report_page.dart';
import '../models/plant_diagnosis.dart';

// Routes constants
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String diagnosis = '/diagnosis';
  static const String actions = '/actions';
  static const String report = '/report';
  static const String map = '/map';
  static const String sentinel = '/sentinel';
  static const String history = '/history';
  
  // Producer routes
  static const String producerDashboard = '/producer/dashboard';
  static const String pdfReport = '/pdf-report';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SplashPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Home
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // Scanner
      GoRoute(
        path: AppRoutes.scan,
        name: 'scan',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ScanPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // Diagnosis
      GoRoute(
        path: AppRoutes.diagnosis,
        name: 'diagnosis',
        pageBuilder: (context, state) {
          final diagnosis = state.extra as PlantDiagnosis?;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: DiagnosisPage(diagnosis: diagnosis),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation.drive(
                    Tween(begin: 0.8, end: 1.0)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                ),
              );
            },
          );
        },
      ),

      // AI Actions/Recommendations
      GoRoute(
        path: AppRoutes.actions,
        name: 'actions',
        pageBuilder: (context, state) {
          final diagnosis = state.extra as PlantDiagnosis?;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ActionsPage(diagnosis: diagnosis),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: child,
              );
            },
          );
        },
      ),

      // Report
      GoRoute(
        path: AppRoutes.report,
        name: 'report',
        pageBuilder: (context, state) {
          final diagnosis = state.extra as PlantDiagnosis?;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ReportPage(diagnosis: diagnosis),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return ScaleTransition(
                scale: animation.drive(
                  Tween(begin: 0.8, end: 1.0)
                      .chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: child,
              );
            },
          );
        },
      ),

      // Community Map
      GoRoute(
        path: AppRoutes.map,
        name: 'map',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MapPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // Sentinel Mode
      GoRoute(
        path: AppRoutes.sentinel,
        name: 'sentinel',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SentinelPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),

      // History
      GoRoute(
        path: AppRoutes.history,
        name: 'history',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HistoryPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // Producer Dashboard
      GoRoute(
        path: AppRoutes.producerDashboard,
        name: 'producer_dashboard',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ProducerDashboardPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        ),
      ),

      // PDF Report
      GoRoute(
        path: AppRoutes.pdfReport,
        name: 'pdf_report',
        pageBuilder: (context, state) {
          final diagnosis = state.extra as PlantDiagnosis?;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: PdfReportPage(diagnosis: diagnosis),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation.drive(
                    Tween(begin: 0.8, end: 1.0)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Erreur: ${state.error}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Extension pour faciliter la navigation
extension GoRouterExtension on GoRouter {
  void pushWithSlideTransition(String path, {Object? extra}) {
    push(path, extra: extra);
  }

  void pushWithFadeTransition(String path, {Object? extra}) {
    push(path, extra: extra);
  }

  void pushWithScaleTransition(String path, {Object? extra}) {
    push(path, extra: extra);
  }
}
