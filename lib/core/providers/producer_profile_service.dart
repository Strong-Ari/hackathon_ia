import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../models/producer_profile_model.dart';

final producerProfileServiceProvider = Provider<ProducerProfileService>((ref) {
  return ProducerProfileService();
});

final producerProfileProvider = StateNotifierProvider<ProducerProfileNotifier, AsyncValue<ProducerProfile?>>((ref) {
  final service = ref.watch(producerProfileServiceProvider);
  return ProducerProfileNotifier(service);
});

class ProducerProfileService {
  static const String _profileKey = 'producer_profile';
  final ImagePicker _imagePicker = ImagePicker();

  /// Charge le profil depuis SharedPreferences
  Future<ProducerProfile?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null) {
        final profileData = jsonDecode(profileJson);
        return ProducerProfile.fromJson(profileData);
      }
      
      return null;
    } catch (e) {
      debugPrint('Erreur lors du chargement du profil: $e');
      return null;
    }
  }

  /// Sauvegarde le profil dans SharedPreferences
  Future<void> saveProfile(ProducerProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde du profil: $e');
      throw Exception('Impossible de sauvegarder le profil');
    }
  }

  /// Crée un profil par défaut
  ProducerProfile createDefaultProfile() {
    final now = DateTime.now();
    return ProducerProfile(
      id: 'producer_${now.millisecondsSinceEpoch}',
      name: '',
      email: '',
      phone: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Sélectionne et sauvegarde une photo de profil
  Future<String?> pickAndSaveProfilePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageToAppDirectory(image, 'profile_photo');
      }
      
      return null;
    } catch (e) {
      debugPrint('Erreur lors de la sélection de la photo: $e');
      throw Exception('Impossible de sélectionner la photo');
    }
  }

  /// Sélectionne et sauvegarde une photo de production
  Future<String?> pickAndSaveProductionPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        return await _saveImageToAppDirectory(image, 'production_$timestamp');
      }
      
      return null;
    } catch (e) {
      debugPrint('Erreur lors de la sélection de la photo: $e');
      throw Exception('Impossible de sélectionner la photo');
    }
  }

  /// Prend une photo avec la caméra
  Future<String?> takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        return await _saveImageToAppDirectory(image, 'camera_$timestamp');
      }
      
      return null;
    } catch (e) {
      debugPrint('Erreur lors de la prise de photo: $e');
      throw Exception('Impossible de prendre la photo');
    }
  }

  /// Sauvegarde une image dans le répertoire de l'application
  Future<String> _saveImageToAppDirectory(XFile image, String filename) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'images'));
      
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final extension = path.extension(image.path);
      final newPath = path.join(imagesDir.path, '$filename$extension');
      
      await File(image.path).copy(newPath);
      return newPath;
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de l\'image: $e');
      throw Exception('Impossible de sauvegarder l\'image');
    }
  }

  /// Supprime une image
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'image: $e');
    }
  }

  /// Supprime le profil
  Future<void> deleteProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
    } catch (e) {
      debugPrint('Erreur lors de la suppression du profil: $e');
      throw Exception('Impossible de supprimer le profil');
    }
  }
}

class ProducerProfileNotifier extends StateNotifier<AsyncValue<ProducerProfile?>> {
  final ProducerProfileService _service;

  ProducerProfileNotifier(this._service) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  /// Charge le profil
  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();
      final profile = await _service.loadProfile();
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Met à jour le profil
  Future<void> updateProfile(ProducerProfile profile) async {
    try {
      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
      await _service.saveProfile(updatedProfile);
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Crée un nouveau profil
  Future<void> createProfile(ProducerProfile profile) async {
    try {
      await _service.saveProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Ajoute une production
  Future<void> addProduction(Production production) async {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProductions = [...currentProfile.productions, production];
      final updatedProfile = currentProfile.copyWith(
        productions: updatedProductions,
        updatedAt: DateTime.now(),
      );
      await updateProfile(updatedProfile);
    }
  }

  /// Met à jour une production
  Future<void> updateProduction(Production production) async {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProductions = currentProfile.productions.map((p) {
        return p.id == production.id ? production : p;
      }).toList();
      
      final updatedProfile = currentProfile.copyWith(
        productions: updatedProductions,
        updatedAt: DateTime.now(),
      );
      await updateProfile(updatedProfile);
    }
  }

  /// Supprime une production
  Future<void> deleteProduction(String productionId) async {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final production = currentProfile.productions.firstWhere(
        (p) => p.id == productionId,
      );
      
      // Supprimer les photos associées
      for (final photoPath in production.photos) {
        await _service.deleteImage(photoPath);
      }
      
      final updatedProductions = currentProfile.productions
          .where((p) => p.id != productionId)
          .toList();
      
      final updatedProfile = currentProfile.copyWith(
        productions: updatedProductions,
        updatedAt: DateTime.now(),
      );
      await updateProfile(updatedProfile);
    }
  }

  /// Met à jour la photo de profil
  Future<void> updateProfilePhoto() async {
    try {
      final newPhotoPath = await _service.pickAndSaveProfilePhoto();
      if (newPhotoPath != null) {
        final currentProfile = state.value;
        if (currentProfile != null) {
          // Supprimer l'ancienne photo si elle existe
          if (currentProfile.photoPath != null) {
            await _service.deleteImage(currentProfile.photoPath!);
          }
          
          final updatedProfile = currentProfile.copyWith(
            photoPath: newPhotoPath,
            updatedAt: DateTime.now(),
          );
          await updateProfile(updatedProfile);
        }
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Supprime le profil
  Future<void> deleteProfile() async {
    try {
      final currentProfile = state.value;
      if (currentProfile != null) {
        // Supprimer la photo de profil
        if (currentProfile.photoPath != null) {
          await _service.deleteImage(currentProfile.photoPath!);
        }
        
        // Supprimer toutes les photos de production
        for (final production in currentProfile.productions) {
          for (final photoPath in production.photos) {
            await _service.deleteImage(photoPath);
          }
        }
      }
      
      await _service.deleteProfile();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}