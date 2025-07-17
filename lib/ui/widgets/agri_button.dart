import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

enum AgriButtonType {
  primary,
  secondary,
  outlined,
  text,
  scanner,
}

enum AgriButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class AgriButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AgriButtonType type;
  final AgriButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;
  final String? heroTag;
  final bool enableGlow;
  final bool enablePulse;

  const AgriButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AgriButtonType.primary,
    this.size = AgriButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customColor,
    this.heroTag,
    this.enableGlow = false,
    this.enablePulse = false,
  });

  @override
  State<AgriButton> createState() => _AgriButtonState();
}

class _AgriButtonState extends State<AgriButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
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

  double get _buttonHeight {
    switch (widget.size) {
      case AgriButtonSize.small:
        return AppDimensions.buttonHeightSM;
      case AgriButtonSize.medium:
        return AppDimensions.buttonHeight;
      case AgriButtonSize.large:
        return AppDimensions.buttonHeightLG;
      case AgriButtonSize.extraLarge:
        return 80.0;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case AgriButtonSize.small:
        return 14.0;
      case AgriButtonSize.medium:
        return 16.0;
      case AgriButtonSize.large:
        return 18.0;
      case AgriButtonSize.extraLarge:
        return 20.0;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case AgriButtonSize.small:
        return AppDimensions.iconSM;
      case AgriButtonSize.medium:
        return AppDimensions.iconMD;
      case AgriButtonSize.large:
        return AppDimensions.iconLG;
      case AgriButtonSize.extraLarge:
        return AppDimensions.iconXL;
    }
  }

  Widget _buildButton() {
    Widget button;

    switch (widget.type) {
      case AgriButtonType.primary:
        button = _buildPrimaryButton();
        break;
      case AgriButtonType.secondary:
        button = _buildSecondaryButton();
        break;
      case AgriButtonType.outlined:
        button = _buildOutlinedButton();
        break;
      case AgriButtonType.text:
        button = _buildTextButton();
        break;
      case AgriButtonType.scanner:
        button = _buildScannerButton();
        break;
    }

    if (widget.heroTag != null) {
      button = Hero(
        tag: widget.heroTag!,
        child: button,
      );
    }

    return button;
  }

  Widget _buildPrimaryButton() {
    return Container(
      width: widget.isFullWidth ? double.infinity : null,
      height: _buttonHeight,
      decoration: BoxDecoration(
        gradient: widget.customColor != null
            ? LinearGradient(
                colors: [widget.customColor!, widget.customColor!.withOpacity(0.8)],
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: widget.enableGlow
            ? [
                BoxShadow(
                  color: (widget.customColor ?? AppColors.primaryGreen).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLG,
              vertical: AppDimensions.paddingMD,
            ),
            child: _buildButtonContent(AppColors.textOnDark),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return Container(
      width: widget.isFullWidth ? double.infinity : null,
      height: _buttonHeight,
      decoration: BoxDecoration(
        color: widget.customColor ?? AppColors.accentGold,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLG,
              vertical: AppDimensions.paddingMD,
            ),
            child: _buildButtonContent(AppColors.textOnLight),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return Container(
      width: widget.isFullWidth ? double.infinity : null,
      height: _buttonHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.customColor ?? AppColors.primaryGreen,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLG,
              vertical: AppDimensions.paddingMD,
            ),
            child: _buildButtonContent(
              widget.customColor ?? AppColors.primaryGreen,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size(AppDimensions.buttonMinWidth, _buttonHeight),
      ),
      child: _buildButtonContent(
        widget.customColor ?? AppColors.primaryGreen,
      ),
    );
  }

  Widget _buildScannerButton() {
    return Container(
      width: widget.isFullWidth ? double.infinity : null,
      height: _buttonHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.scannerFrame,
            Color(0xFF00C853),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.scannerFrame.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL,
              vertical: AppDimensions.paddingLG,
            ),
            child: _buildButtonContent(AppColors.textOnDark),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    if (widget.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _iconSize * 0.8,
            height: _iconSize * 0.8,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSM),
          Text(
            'Chargement...',
            style: TextStyle(
              color: textColor,
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: _iconSize,
            color: textColor,
          ),
          const SizedBox(width: AppDimensions.spaceSM),
          Text(
            widget.text,
            style: TextStyle(
              color: textColor,
              fontSize: _fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.text,
      style: TextStyle(
        color: textColor,
        fontSize: _fontSize,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildButton(),
        );
      },
    );

    if (widget.enablePulse) {
      button = button
          .animate(onPlay: (controller) => controller.repeat())
          .scale(
            duration: 2000.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            curve: Curves.easeInOut,
          )
          .then()
          .scale(
            duration: 2000.ms,
            begin: const Offset(1.05, 1.05),
            end: const Offset(1.0, 1.0),
            curve: Curves.easeInOut,
          );
    }

    if (widget.enableGlow) {
      button = button
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .boxShadow(
            duration: 2000.ms,
            begin: BoxShadow(
              color: (widget.customColor ?? AppColors.primaryGreen).withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
            end: BoxShadow(
              color: (widget.customColor ?? AppColors.primaryGreen).withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 3,
            ),
          );
    }

    return button;
  }
}
