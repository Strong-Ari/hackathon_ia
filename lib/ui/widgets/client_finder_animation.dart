import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ClientFinderAnimation extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  
  const ClientFinderAnimation({
    super.key,
    this.onAnimationComplete,
  });

  @override
  State<ClientFinderAnimation> createState() => _ClientFinderAnimationState();
}

class _ClientFinderAnimationState extends State<ClientFinderAnimation>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _pulseController;
  late AnimationController _mapController;
  bool _isSearching = false;
  bool _foundClient = false;
  
  // Position simulée du producteur au centre
  static const Offset producerPosition = Offset(0.5, 0.5);
  
  // Clients fictifs avec leurs positions relatives
  final List<MockClient> _clients = [
    MockClient(
      name: "Marie Dubois",
      position: Offset(0.6, 0.3),
      interest: "Légumes bio",
      avatar: "👩‍🦳",
      distance: "2.3 km",
    ),
    MockClient(
      name: "Pierre Martin",
      position: Offset(0.3, 0.7),
      interest: "Fruits de saison",
      avatar: "👨‍💼",
      distance: "1.8 km",
    ),
    MockClient(
      name: "Sophie Chen",
      position: Offset(0.7, 0.6),
      interest: "Produits locaux",
      avatar: "👩‍🔬",
      distance: "3.1 km",
    ),
    MockClient(
      name: "Restaurant Bio+",
      position: Offset(0.4, 0.4),
      interest: "Légumes bio en gros",
      avatar: "🏪",
      distance: "1.5 km",
    ),
  ];
  
  MockClient? _matchedClient;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _mapController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _startSearch() async {
    setState(() {
      _isSearching = true;
      _foundClient = false;
      _matchedClient = null;
    });
    
    // Animation de la carte qui apparaît
    _mapController.forward();
    
    // Démarrer l'animation radar en boucle
    _radarController.repeat();
    
    // Attendre 2.5 secondes puis simuler un match
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (mounted) {
      _radarController.stop();
      
      // Choisir un client aléatoire
      final random = math.Random();
      _matchedClient = _clients[random.nextInt(_clients.length)];
      
      setState(() {
        _foundClient = true;
      });
      
      // Démarrer l'animation de pulsation du client trouvé
      _pulseController.repeat(reverse: true);
      
      // Arrêter l'animation après 3 secondes et notifier
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          widget.onAnimationComplete?.call();
        }
      });
    }
  }

  void _resetAnimation() {
    setState(() {
      _isSearching = false;
      _foundClient = false;
      _matchedClient = null;
    });
    _radarController.reset();
    _pulseController.reset();
    _mapController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '🎯',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IA Recherche de Clients',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    Text(
                      'Trouvez des acheteurs dans votre région',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Mini carte avec animation
          AnimatedBuilder(
            animation: _mapController,
            builder: (context, child) {
              return Transform.scale(
                scale: _mapController.value,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        // Fond de carte stylisé
                        _buildMapBackground(),
                        
                        // Animation radar
                        if (_isSearching && !_foundClient)
                          _buildRadarAnimation(),
                        
                        // Producteur au centre
                        _buildProducerMarker(),
                        
                        // Clients sur la carte
                        ..._buildClientMarkers(),
                        
                        // Overlay de résultat
                        if (_foundClient && _matchedClient != null)
                          _buildMatchOverlay(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Bouton d'action
          if (!_isSearching)
            ElevatedButton.icon(
              onPressed: _startSearch,
              icon: const Icon(Icons.radar, color: Colors.white),
              label: const Text(
                '🎯 Trouver des clients',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4CAF50)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _foundClient ? 'Client trouvé !' : 'Recherche en cours...',
                    style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          // Bouton reset
          if (_isSearching || _foundClient)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton(
                onPressed: _resetAnimation,
                child: const Text('Recommencer'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E8),
            Color(0xFFF0F8F0),
          ],
        ),
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: MapBackgroundPainter(),
      ),
    );
  }

  Widget _buildRadarAnimation() {
    return AnimatedBuilder(
      animation: _radarController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: RadarPainter(_radarController.value),
        );
      },
    );
  }

  Widget _buildProducerMarker() {
    return Positioned(
      left: producerPosition.dx * 200 - 20,
      top: producerPosition.dy * 200 - 20,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '🧑‍🌾',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildClientMarkers() {
    return _clients.map((client) {
      final isMatched = _foundClient && client == _matchedClient;
      
      return Positioned(
        left: client.position.dx * 200 - 15,
        top: client.position.dy * 200 - 15,
        child: AnimatedBuilder(
          animation: isMatched ? _pulseController : const AlwaysStoppedAnimation(0),
          builder: (context, child) {
            final scale = isMatched ? 1.0 + (_pulseController.value * 0.3) : 1.0;
            
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isMatched ? const Color(0xFFFF9800) : Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isMatched ? const Color(0xFFFF9800) : Colors.blue)
                          .withOpacity(0.3),
                      blurRadius: isMatched ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    client.avatar,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  Widget _buildMatchOverlay() {
    if (_matchedClient == null) return const SizedBox.shrink();
    
    return Positioned(
      right: 8,
      bottom: 8,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9800),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _matchedClient!.avatar,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  _matchedClient!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Text(
              _matchedClient!.interest,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            Text(
              _matchedClient!.distance,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ).animate()
        .slideY(begin: 0.5, duration: 400.ms)
        .fadeIn(duration: 400.ms),
    );
  }
}

class MockClient {
  final String name;
  final Offset position;
  final String interest;
  final String avatar;
  final String distance;

  MockClient({
    required this.name,
    required this.position,
    required this.interest,
    required this.avatar,
    required this.distance,
  });
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    // Dessiner des "routes" stylisées
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.1,
      size.width * 0.8, size.height * 0.4,
    );
    
    path.moveTo(size.width * 0.1, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.4, size.height * 0.6,
      size.width * 0.9, size.height * 0.8,
    );

    canvas.drawPath(path, paint);

    // Ajouter quelques "bâtiments" stylisés
    final buildingPaint = Paint()
      ..color = Colors.grey[400]!;

    canvas.drawRect(Rect.fromLTWH(20, 40, 15, 15), buildingPaint);
    canvas.drawRect(Rect.fromLTWH(160, 80, 12, 12), buildingPaint);
    canvas.drawRect(Rect.fromLTWH(50, 140, 18, 18), buildingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadarPainter extends CustomPainter {
  final double progress;

  RadarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final maxRadius = math.min(size.width, size.height) * 0.4;

    // Dessiner les ondes concentriques
    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * ((progress + i * 0.3) % 1.0);
      final opacity = 1.0 - ((progress + i * 0.3) % 1.0);
      
      final paint = Paint()
        ..color = const Color(0xFF4CAF50).withOpacity(opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}