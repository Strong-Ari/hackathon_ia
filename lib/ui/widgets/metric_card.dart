import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class MetricCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showTrendIcon;
  final bool isLoading;
  final int animationDelay;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.subtitle,
    this.onTap,
    this.showTrendIcon = true,
    this.isLoading = false,
    this.animationDelay = 0,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
    ));

    // Démarrer l'animation avec delay
    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.1),
                      offset: const Offset(0, 8),
                      blurRadius: 24,
                    ),
                    BoxShadow(
                      color: AppColors.shadowLight,
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Gradient décoratif subtil
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              widget.color.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                        ),
                      ),
                    ),
                    
                    // Contenu principal
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingLG),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header avec icône et trend
                          _buildHeader(),
                          
                          const Spacer(),
                          
                          // Valeur principale
                          _buildValue(),
                          
                          const SizedBox(height: AppDimensions.spaceXS),
                          
                          // Titre et sous-titre
                          _buildTitleSection(),
                        ],
                      ),
                    ),
                    
                    // Indicateur de chargement
                    if (widget.isLoading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Icône avec animation de rotation
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingSM),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: Icon(
            widget.icon,
            color: widget.color,
            size: AppDimensions.iconMD,
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .rotate(
              duration: 4000.ms,
              begin: 0.0,
              end: 0.05,
              curve: Curves.easeInOut,
            ),
        
        // Badge de trend
        if (widget.trend != null)
          _buildTrendBadge(),
      ],
    );
  }

  Widget _buildTrendBadge() {
    final isPositive = widget.trend!.startsWith('+');
    final isNeutral = widget.trend!.toLowerCase().contains('optimal') || 
                      widget.trend!.toLowerCase().contains('stable') ||
                      widget.trend!.toLowerCase().contains('actif');
    
    Color trendColor;
    IconData trendIcon;
    
    if (isNeutral) {
      trendColor = AppColors.statusHealthy;
      trendIcon = PhosphorIcons.checkCircle();
    } else if (isPositive) {
      trendColor = AppColors.statusHealthy;
      trendIcon = PhosphorIcons.trendUp();
    } else {
      trendColor = AppColors.statusWarning;
      trendIcon = PhosphorIcons.trendDown();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(
          color: trendColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showTrendIcon) ...[
            Icon(
              trendIcon,
              size: 12,
              color: trendColor,
            ),
            const SizedBox(width: AppDimensions.spaceXS),
          ],
          Text(
            widget.trend!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 800.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          delay: 800.ms,
          curve: Curves.elasticOut,
        );
  }

  Widget _buildValue() {
    return Text(
      widget.value,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          delay: 400.ms,
          curve: Curves.easeOut,
        )
        .then()
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(
          duration: 3000.ms,
          color: widget.color.withOpacity(0.2),
        );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 600.ms)
            .slideX(
              begin: -0.2,
              end: 0.0,
              duration: 600.ms,
              delay: 600.ms,
            ),
        
        if (widget.subtitle != null) ...[
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            widget.subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 700.ms),
        ],
      ],
    );
  }
}

// Widget spécialisé pour les métriques de santé avec gauge
class HealthMetricCard extends StatefulWidget {
  final String title;
  final double percentage;
  final Color color;
  final String status;
  final int animationDelay;

  const HealthMetricCard({
    super.key,
    required this.title,
    required this.percentage,
    required this.color,
    required this.status,
    this.animationDelay = 0,
  });

  @override
  State<HealthMetricCard> createState() => _HealthMetricCardState();
}

class _HealthMetricCardState extends State<HealthMetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.color.withOpacity(0.1),
            widget.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: widget.color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spaceLG),
          
          // Gauge circulaire
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cercle de fond
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
                
                // Gauge animée
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(140, 140),
                      painter: CircularGaugePainter(
                        percentage: _progressAnimation.value,
                        color: widget.color,
                      ),
                    );
                  },
                ),
                
                // Valeur centrale
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Text(
                          '${_progressAnimation.value.toInt()}%',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                          ),
                        );
                      },
                    ),
                    Text(
                      widget.status,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: widget.animationDelay.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 800.ms,
          delay: widget.animationDelay.ms,
          curve: Curves.elasticOut,
        );
  }
}

// Custom Painter pour la gauge circulaire
class CircularGaugePainter extends CustomPainter {
  final double percentage;
  final Color color;

  CircularGaugePainter({
    required this.percentage,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Fond de la gauge
    final backgroundPaint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Gauge de progression avec gradient
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color,
          color.withOpacity(0.7),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (percentage / 100) * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Commencer en haut
      sweepAngle,
      false,
      progressPaint,
    );

    // Points lumineux sur la gauge
    if (percentage > 0) {
      final endAngle = -3.14159 / 2 + sweepAngle;
      final endPoint = Offset(
        center.dx + radius * 0.9 * math.cos(endAngle),
        center.dy + radius * 0.9 * math.sin(endAngle),
      );

      final glowPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(endPoint, 4, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Import nécessaire pour les calculs mathématiques
import 'dart:math' as math;