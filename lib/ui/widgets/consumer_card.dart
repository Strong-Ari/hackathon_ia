import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../config.dart';

// Widget de carte pour l'espace consommateur
class ConsumerCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ConsumerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<ConsumerCard> createState() => _ConsumerCardState();
}

class _ConsumerCardState extends State<ConsumerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConfig.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: _elevationAnimation.value * 3,
                    offset: Offset(0, _elevationAnimation.value),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppConfig.cardRadius),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icône
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Contenu textuel
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.subtitle,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Flèche
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.7),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 600))
      .slideX(begin: 0.3, end: 0, duration: const Duration(milliseconds: 600));
  }
}