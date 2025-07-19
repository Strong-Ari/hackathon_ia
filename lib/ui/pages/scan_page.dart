import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/providers/router_provider.dart';
import '../../core/models/plant_diagnosis.dart';
import '../widgets/agri_button.dart';
import 'dart:math' as math;

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _uiController;

  bool _isScanning = false;
  bool _isCameraReady = false;
  PlantDiagnosis? _lastScan;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _uiController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _initializeCamera();
    _loadLastScan();
  }

  void _initializeCamera() async {
    // Simule l'initialisation de la caméra
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isCameraReady = true;
      });
      _uiController.forward();
    }
  }

  void _loadLastScan() {
    // Charger le dernier scan depuis le cache/base de données
    // Pour l'instant, on simule avec des données mock
    _lastScan = PlantDiagnosis(
      id: 'last_scan_001',
      plantName: 'Maïs',
      diseaseName: 'Rouille commune',
      diseaseType: DiseaseType.fungal,
      status: PlantHealthStatus.warning,
      confidence: 0.92,
      estimatedLoss: 8.3,
      description: 'Infection fongique modérée détectée.',
      symptoms: ['Pustules orange', 'Taches foliaires'],
      treatments: ['Fongicide systémique', 'Rotation des cultures'],
      imagePath: 'assets/images/corn_rust.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      location: const Location(
        latitude: 14.7167,
        longitude: -17.4677,
        address: 'Dakar, Sénégal',
      ),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _uiController.dispose();
    super.dispose();
  }

  void _startScan() async {
    setState(() {
      _isScanning = true;
    });

    _scanController.forward();

    // Simule le scan et l'analyse IA
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      // Créer un diagnostic simulé
      final mockDiagnosis = PlantDiagnosis(
        id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
        plantName: 'Tomate',
        diseaseName: 'Mildiou',
        diseaseType: DiseaseType.fungal,
        status: PlantHealthStatus.warning,
        confidence: 0.87,
        estimatedLoss: 15.5,
        description: 'Infection fongique détectée sur les feuilles inférieures.',
        symptoms: [
          'Taches brunes sur les feuilles',
          'Duvet blanc au revers des feuilles',
          'Flétrissement des tiges'
        ],
        treatments: [
          'Traitement fongicide cuivre',
          'Améliorer la ventilation',
          'Réduire l\'humidité'
        ],
        imagePath: 'assets/images/sample_plant.jpg',
        timestamp: DateTime.now(),
        location: const Location(
          latitude: 14.7167,
          longitude: -17.4677,
          address: 'Dakar, Sénégal',
        ),
      );

      // Mettre à jour le dernier scan
      setState(() {
        _lastScan = mockDiagnosis;
        _isScanning = false;
      });

      _scanController.reset();

      // Naviguer vers le diagnostic
      context.push(AppRoutes.diagnosis, extra: mockDiagnosis);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Scanner IA',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_off, color: Colors.white),
            onPressed: () {
              // Toggle flash
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: () {
              // Switch camera
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Caméra background (simulé)
          _buildCameraView(),
          
          // Overlay de scan
          _buildScanOverlay(),
          
          // Interface utilisateur
          _buildUI(),
          
          // Dernier scan en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildLastScanCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1B5E20).withOpacity(0.8),
            Colors.black.withOpacity(0.9),
            Colors.black,
          ],
        ),
      ),
      child: _isCameraReady
          ? const Icon(
              Icons.camera_alt,
              size: 100,
              color: Colors.white24,
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            ),
    );
  }

  Widget _buildScanOverlay() {
    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          children: [
            // Cadre de scan principal
            _buildScanFrame(),
            
            // Animation de scan en cours
            if (_isScanning) _buildScanningAnimation(),
            
            // Particules flottantes
            _buildParticles(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanFrame() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isScanning ? AppColors.scannerFrame : Colors.white70,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Coins du cadre
          ...List.generate(4, (index) {
            return Positioned(
              top: index < 2 ? 0 : null,
              bottom: index >= 2 ? 0 : null,
              left: index % 2 == 0 ? 0 : null,
              right: index % 2 == 1 ? 0 : null,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border(
                    top: index < 2
                        ? BorderSide(color: AppColors.scannerFrame, width: 4)
                        : BorderSide.none,
                    bottom: index >= 2
                        ? BorderSide(color: AppColors.scannerFrame, width: 4)
                        : BorderSide.none,
                    left: index % 2 == 0
                        ? BorderSide(color: AppColors.scannerFrame, width: 4)
                        : BorderSide.none,
                    right: index % 2 == 1
                        ? BorderSide(color: AppColors.scannerFrame, width: 4)
                        : BorderSide.none,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildScanningAnimation() {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.scannerGlow.withOpacity(0.3 * _scanController.value),
                  Colors.transparent,
                ],
                stops: [
                  0.0,
                  _scanController.value,
                  math.min(_scanController.value + 0.1, 1.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final angle = (index * math.pi / 4) + (_particleController.value * 2 * math.pi);
            final radius = 120 + (20 * math.sin(_particleController.value * 2 * math.pi));
            final x = 140 + radius * math.cos(angle);
            final y = 140 + radius * math.sin(angle);

            return Positioned(
              left: x - 3,
              top: y - 3,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.scannerFrame.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.scannerFrame.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        const Spacer(),
        
        // Instructions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              if (!_isScanning) ...[
                Text(
                  'Pointez votre caméra vers une plante',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate(controller: _uiController)
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 8),
                
                Text(
                  'L\'IA analysera automatiquement la santé de votre culture',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate(controller: _uiController)
                    .fadeIn(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 600),
                    ),
              ] else ...[
                Text(
                  'Analyse en cours...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.scannerFrame,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 200,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white24,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 200 * _scanController.value,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: AppColors.scannerFrame,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.scannerFrame.withOpacity(0.6),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Bouton de scan
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = _isScanning ? 1.0 : (1.0 + 0.1 * math.sin(_pulseController.value * 2 * math.pi));
            
            return Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: _isScanning ? null : _startScan,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isScanning ? Colors.white24 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isScanning ? Icons.hourglass_empty : Icons.camera,
                    size: 32,
                    color: _isScanning ? Colors.white54 : AppColors.primaryGreen,
                  ),
                ),
              ),
            );
          },
        )
            .animate(controller: _uiController)
            .fadeIn(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 600),
            )
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
            ),
        
        const SizedBox(height: 140), // Espace pour la carte du dernier scan
      ],
    );
  }

  Widget _buildLastScanCard() {
    if (_lastScan == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Dernier scan',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                _formatTime(_lastScan!.timestamp),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              // Image miniature
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryGreen.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.eco,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _lastScan!.plantName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(_lastScan!.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _lastScan!.diseaseName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Bouton d'action
              GestureDetector(
                onTap: () => context.push(AppRoutes.diagnosis, extra: _lastScan),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate(controller: _uiController)
        .fadeIn(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 600),
        )
        .slideY(begin: 1.0, end: 0);
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return 'Il y a ${difference.inDays}j';
    }
  }

  Color _getStatusColor(PlantHealthStatus status) {
    switch (status) {
      case PlantHealthStatus.healthy:
        return AppColors.statusHealthy;
      case PlantHealthStatus.warning:
        return AppColors.statusWarning;
      case PlantHealthStatus.danger:
        return AppColors.statusDanger;
      case PlantHealthStatus.critical:
        return AppColors.statusCritical;
    }
  }
}
