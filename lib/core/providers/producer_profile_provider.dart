import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/producer_profile.dart';

// Provider pour le profil du producteur
final producerProfileProvider = StateNotifierProvider<ProducerProfileNotifier, ProducerProfile?>((ref) {
  return ProducerProfileNotifier();
});

class ProducerProfileNotifier extends StateNotifier<ProducerProfile?> {
  ProducerProfileNotifier() : super(null) {
    _loadProfile();
  }

  static const String _storageKey = 'producer_profile';

  // Charger le profil depuis le stockage local
  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_storageKey);
      
      if (profileJson != null) {
        final profile = ProducerProfile.fromJson(jsonDecode(profileJson));
        state = profile;
      } else {
        // Créer un profil par défaut
        state = _createDefaultProfile();
        await _saveProfile();
      }
    } catch (e) {
      print('Erreur lors du chargement du profil: $e');
      state = _createDefaultProfile();
    }
  }

  // Créer un profil par défaut
  ProducerProfile _createDefaultProfile() {
    return ProducerProfile(
      id: 'producer_001',
      fullName: 'Jean Dupont',
      description: 'Producteur bio passionné depuis 15 ans, spécialisé dans les légumes de saison et les fruits rouges. Ferme familiale située dans la vallée de la Loire.',
      productions: [
        ProductionItem(
          id: '1',
          type: 'Tomates bio',
          quantity: '500 kg/saison',
          season: 'Été',
          status: ProductionStatus.enStock,
        ),
        ProductionItem(
          id: '2',
          type: 'Courgettes',
          quantity: '300 kg/saison',
          season: 'Été',
          status: ProductionStatus.enCroissance,
        ),
        ProductionItem(
          id: '3',
          type: 'Pommes de terre',
          quantity: '1 tonne/saison',
          season: 'Automne',
          status: ProductionStatus.recolte,
        ),
        ProductionItem(
          id: '4',
          type: 'Fraises',
          quantity: '200 kg/saison',
          season: 'Printemps',
          status: ProductionStatus.vendu,
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Sauvegarder le profil dans le stockage local
  Future<void> _saveProfile() async {
    if (state == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(state!.toJson());
      await prefs.setString(_storageKey, profileJson);
    } catch (e) {
      print('Erreur lors de la sauvegarde du profil: $e');
    }
  }

  // Mettre à jour le profil
  Future<void> updateProfile(ProducerProfile updatedProfile) async {
    state = updatedProfile.copyWith(updatedAt: DateTime.now());
    await _saveProfile();
  }

  // Mettre à jour uniquement les informations de base
  Future<void> updateBasicInfo({
    String? fullName,
    String? description,
    String? profileImageUrl,
  }) async {
    if (state == null) return;

    state = state!.copyWith(
      fullName: fullName ?? state!.fullName,
      description: description ?? state!.description,
      profileImageUrl: profileImageUrl ?? state!.profileImageUrl,
      updatedAt: DateTime.now(),
    );
    await _saveProfile();
  }

  // Ajouter une nouvelle production
  Future<void> addProduction(ProductionItem production) async {
    if (state == null) return;

    final updatedProductions = [...state!.productions, production];
    state = state!.copyWith(
      productions: updatedProductions,
      updatedAt: DateTime.now(),
    );
    await _saveProfile();
  }

  // Mettre à jour une production existante
  Future<void> updateProduction(ProductionItem updatedProduction) async {
    if (state == null) return;

    final updatedProductions = state!.productions.map((production) {
      return production.id == updatedProduction.id ? updatedProduction : production;
    }).toList();

    state = state!.copyWith(
      productions: updatedProductions,
      updatedAt: DateTime.now(),
    );
    await _saveProfile();
  }

  // Supprimer une production
  Future<void> removeProduction(String productionId) async {
    if (state == null) return;

    final updatedProductions = state!.productions
        .where((production) => production.id != productionId)
        .toList();

    state = state!.copyWith(
      productions: updatedProductions,
      updatedAt: DateTime.now(),
    );
    await _saveProfile();
  }

  // Réinitialiser le profil
  Future<void> resetProfile() async {
    state = _createDefaultProfile();
    await _saveProfile();
  }
}