import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/client_model.dart';

class ClientSearchAnimation extends StatefulWidget {
  final List<Client> clients;
  final Function(Client) onClientSelected;
  final VoidCallback onSearchComplete;

  const ClientSearchAnimation({
    super.key,
    required this.clients,
    required this.onClientSelected,
    required this.onSearchComplete,
  });

  @override
  State<ClientSearchAnimation> createState() => _ClientSearchAnimationState();
}

class _ClientSearchAnimationState extends State<ClientSearchAnimation>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _pulseController;
  late AnimationController _clientAppearController;
  
  int _currentClientIndex = 0;
  bool _showClient = false;

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
    
    _clientAppearController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Démarrer l'animation radar
    _radarController.repeat();
    
    // Attendre un peu puis faire apparaître les clients un par un
    await Future.delayed(const Duration(seconds: 1));
    
    for (int i = 0; i < widget.clients.length; i++) {
      setState(() {
        _currentClientIndex = i;
        _showClient = true;
      });
      
      _clientAppearController.forward();
      _pulseController.repeat();
      
      // Attendre avant le prochain client
      await Future.delayed(const Duration(seconds: 2));
      
      if (i < widget.clients.length - 1) {
        _clientAppearController.reset();
        _pulseController.reset();
        setState(() {
          _showClient = false;
        });
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    
    // Animation terminée
    _radarController.stop();
    _pulseController.stop();
    widget.onSearchComplete();
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _clientAppearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Animation radar
          Center(
            child: _buildRadarAnimation(),
          ),
          
          // Client trouvé
          if (_showClient && _currentClientIndex < widget.clients.length)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: _buildClientCard(widget.clients[_currentClientIndex]),
            ),
        ],
      ),
    );
  }

  Widget _buildRadarAnimation() {
    return AnimatedBuilder(
      animation: _radarController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _radarController.value * 2 * 3.14159,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Cercle radar
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                
                // Ligne de scan
                Positioned(
                  top: 100,
                  left: 100,
                  child: Container(
                    width: 1,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.8),
                          AppColors.primaryGreen.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildClientCard(Client client) {
    return AnimatedBuilder(
      animation: _clientAppearController,
      builder: (context, child) {
        return Transform.scale(
          scale: _clientAppearController.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar du client
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ).animate().scale(
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                ),
                
                const SizedBox(height: 12),
                
                // Nom du client
                Text(
                  client.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Intérêt
                Text(
                  client.interest,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Localisation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      client.location,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Badge "Intéressé"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.statusHealthy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.statusHealthy,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 16,
                        color: AppColors.statusHealthy,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Intéressé',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.statusHealthy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ).animate().pulse(
                  duration: 800.ms,
                  curve: Curves.easeInOut,
                ).repeat(),
              ],
            ),
          ),
        );
      },
    );
  }
}