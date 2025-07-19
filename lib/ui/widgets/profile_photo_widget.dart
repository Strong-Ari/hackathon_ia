import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_colors.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final String? photoPath;
  final bool isEditing;
  final VoidCallback? onPhotoTap;
  final double size;

  const ProfilePhotoWidget({
    super.key,
    this.photoPath,
    this.isEditing = false,
    this.onPhotoTap,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditing ? onPhotoTap : null,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withOpacity(0.1),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildPhotoContent(),
            ),
          ),
          
          // Badge d'édition
          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.accentGold,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ).animate()
             .scale(delay: 300.ms, duration: 400.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildPhotoContent() {
    if (photoPath != null && photoPath!.isNotEmpty) {
      return Image.file(
        File(photoPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    }
    
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withOpacity(0.2),
            AppColors.primaryGreen.withOpacity(0.1),
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: AppColors.primaryGreen.withOpacity(0.7),
      ),
    );
  }
}