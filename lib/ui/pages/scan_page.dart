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

  bool _isScanning = false;
  bool _isCameraReady = false;

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

    _initializeCamera();
  }

  void _initializeCamera() async {
    // Simule l'initialisation de la caméra
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isCameraReady = true;
      });
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
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
        id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
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
          latitude: 14.6928,
          longitude: -17.4467,
          address: 'Dakar, Sénégal',
        ),
      );

      context.push(AppRoutes.diagnosis, extra: mockDiagnosis);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fond caméra simulé
          _buildCameraView(),

          // Overlay scanner
          _buildScannerOverlay(),

          // Interface utilisateur
          _buildUserInterface(),
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
            Colors.grey[800]!,
            Colors.grey[900]!,
            Colors.black,
          ],
        ),
      ),
      child: _isCameraReady
          ? Stack(
              children: [
                // Simule le feed caméra avec un pattern
                ...List.generate(20, (index) {
                  return AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      final offset = _particleController.value * 2 * 3.14159;
                      final x = (index * 50.0) % MediaQuery.of(context).size.width;
                      final y = (index * 80.0 + offset * 100) % MediaQuery.of(context).size.height;

                      return Positioned(
                        left: x,
                        top: y,
                        child: Container(
                          width: 2,
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  );
                }),

                // Zone d'exemple de plante
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryGreen.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.eco_outlined,
                        size: 80,
                        color: AppColors.primaryGreen.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.scannerFrame,
              ),
            ),
    );
  }

  Widget _buildScannerOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Overlay sombre
          Container(
            color: AppColors.scannerOverlay,
          ),

          // Zone de scan circulaire
          Center(
            child: Container(
              width: AppDimensions.scannerOverlaySize,
              height: AppDimensions.scannerOverlaySize,
              child: Stack(
                children: [
                  // Trou transparent
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.transparent,
                        width: 20,
                      ),
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.clear,
                        ),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),

                  // Frame de scan animé
                  _buildAnimatedScanFrame(),

                  // Ligne de scan
                  if (_isScanning) _buildScanLine(),

                  // Particules de scan
                  if (_isScanning) _buildScanParticles(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedScanFrame() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = _pulseController.value;

        return Container(
          width: AppDimensions.scannerOverlaySize,
          height: AppDimensions.scannerOverlaySize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.scannerFrame.withOpacity(0.8 + 0.2 * pulseValue),
              width: AppDimensions.scannerFrameStroke,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.scannerFrame.withOpacity(0.3 + 0.3 * pulseValue),
                blurRadius: 20 + 10 * pulseValue,
                spreadRadius: 2 + 3 * pulseValue,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Coins du scanner
              ...List.generate(4, (index) {
                return _buildCorner(index, pulseValue);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCorner(int index, double pulseValue) {
    late Alignment alignment;
    late double rotationAngle;

    switch (index) {
      case 0: // Top-left
        alignment = Alignment.topLeft;
        rotationAngle = 0;
        break;
      case 1: // Top-right
        alignment = Alignment.topRight;
        rotationAngle = 1.5708; // 90 degrees
        break;
      case 2: // Bottom-right
        alignment = Alignment.bottomRight;
        rotationAngle = 3.14159; // 180 degrees
        break;
      case 3: // Bottom-left
        alignment = Alignment.bottomLeft;
        rotationAngle = 4.71239; // 270 degrees
        break;
    }

    return Align(
      alignment: alignment,
      child: Transform.rotate(
        angle: rotationAngle,
        child: Container(
          width: AppDimensions.scannerCornerLength,
          height: AppDimensions.scannerCornerLength,
          child: CustomPaint(
            painter: CornerPainter(
              color: AppColors.scannerFrame.withOpacity(0.9 + 0.1 * pulseValue),
              strokeWidth: AppDimensions.scannerFrameStroke,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanLine() {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return Positioned(
          top: AppDimensions.scannerOverlaySize * _scanController.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.scannerFrame,
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.scannerFrame.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScanParticles() {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (index) {
            final angle = (index * 30.0) * (3.14159 / 180);
            final radius = 100 * _scanController.value;
            final x = 125 + radius * math.cos(angle);
            final y = 125 + radius * math.sin(angle);

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.scannerFrame.withOpacity(1 - _scanController.value),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.scannerFrame.withOpacity(0.4),
                      blurRadius: 4,
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

  Widget _buildUserInterface() {
    return SafeArea(
      child: Column(
        children: [
          // En-tête
          _buildHeader(),

          const Spacer(),

          // Instructions
          _buildInstructions(),

          const SizedBox(height: AppDimensions.spaceXXL),

          // Bouton de scan
          _buildScanButton(),

          const SizedBox(height: AppDimensions.spaceXL),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textOnDark,
            ),
          ),
          const Spacer(),
          Text(
            'Scanner',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Flash toggle
            },
            icon: const Icon(
              Icons.flash_off,
              color: AppColors.textOnDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.marginLG),
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.scannerFrame.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.center_focus_strong,
            color: AppColors.scannerFrame,
            size: AppDimensions.iconLG,
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            _isScanning
                ? 'Analyse IA en cours...'
                : 'Centrez la plante dans le cercle',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(
            _isScanning
                ? 'Veuillez ne pas bouger'
                : 'Assurez-vous que la plante soit bien éclairée',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textOnDark.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return Hero(
      tag: 'scanner_button',
      child: GestureDetector(
        onTap: _isScanning ? null : _startScan,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isScanning ? 80 : 120,
          height: _isScanning ? 80 : 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isScanning
                ? LinearGradient(
                    colors: [
                      AppColors.accentGold,
                      AppColors.accentGoldLight,
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      AppColors.scannerFrame,
                      Color(0xFF00C853),
                    ],
                  ),
            boxShadow: [
              BoxShadow(
                color: (_isScanning ? AppColors.accentGold : AppColors.scannerFrame)
                    .withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: _isScanning
                ? const CircularProgressIndicator(
                    color: AppColors.textOnDark,
                    strokeWidth: 3,
                  )
                : const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: AppColors.textOnDark,
                  ),
          ),
        ),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  CornerPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Draw L-shaped corner
    path.moveTo(0, size.height * 0.6);
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.6, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
