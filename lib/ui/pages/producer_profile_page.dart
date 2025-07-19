import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/producer_profile_model.dart';
import '../../core/providers/producer_profile_service.dart';
import '../widgets/profile_photo_widget.dart';
import '../widgets/production_card_widget.dart';
import '../widgets/production_form_dialog.dart';
import '../widgets/client_finder_animation.dart';

class ProducerProfilePage extends ConsumerStatefulWidget {
  const ProducerProfilePage({super.key});

  @override
  ConsumerState<ProducerProfilePage> createState() =>
      _ProducerProfilePageState();
}

class _ProducerProfilePageState extends ConsumerState<ProducerProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  bool _isEditing = false;

  // Controllers pour les champs d'édition
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _farmingMethodsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _farmingMethodsController.dispose();
    super.dispose();
  }

  void _initializeControllers(ProducerProfile? profile) {
    if (profile != null) {
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone;
      _descriptionController.text = profile.description ?? '';
      _locationController.text = profile.location ?? '';
      _farmingMethodsController.text = profile.farmingMethods ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(producerProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Mon Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _toggleEditMode(profileAsync.value),
              tooltip: 'Modifier le profil',
            ),
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _cancelEdit(),
              tooltip: 'Annuler',
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _saveProfile(profileAsync.value),
              tooltip: 'Sauvegarder',
            ),
          ],
        ],
      ),
      body: profileAsync.when(
        data: (profile) => _buildProfileContent(profile),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
      floatingActionButton: profileAsync.value != null && !_isEditing
          ? FloatingActionButton.extended(
              onPressed: _addProduction,
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle culture'),
              backgroundColor: AppColors.primaryGreen,
            )
          : null,
    );
  }

  Widget _buildProfileContent(ProducerProfile? profile) {
    if (profile == null) {
      return _buildCreateProfileState();
    }

    return FadeTransition(
      opacity: _fadeController,
      child: CustomScrollView(
        slivers: [
          // Header avec photo et informations principales
          SliverToBoxAdapter(child: _buildProfileHeader(profile)),

          // Description
          if (profile.description?.isNotEmpty == true || _isEditing)
            SliverToBoxAdapter(child: _buildDescriptionSection(profile)),

          // Informations détaillées
          SliverToBoxAdapter(child: _buildDetailsSection(profile)),

          // Productions
          SliverToBoxAdapter(child: _buildProductionsHeader(profile)),

          if (profile.productions.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildProductionItem(profile.productions[index], index),
                childCount: profile.productions.length,
              ),
            )
          else
            SliverToBoxAdapter(child: _buildEmptyProductionsState()),

          // Section recherche de clients - n'apparaît que si le profil est complété
          if (_isProfileCompleted(profile))
            SliverToBoxAdapter(child: _buildClientFinderSection()),

          // Espacement final
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProducerProfile profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Photo de profil
          ProfilePhotoWidget(
            photoPath: profile.photoPath,
            isEditing: _isEditing,
            onPhotoTap: _isEditing ? _updateProfilePhoto : null,
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: 16),

          // Nom
          if (_isEditing)
            TextField(
              controller: _nameController,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'Votre nom',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              textAlign: TextAlign.center,
            )
          else
            Text(
              profile.name.isEmpty ? 'Nom non renseigné' : profile.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().slideY(
              begin: 0.3,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),

          const SizedBox(height: 8),

          // Badge producteur
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🌾', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  'Producteur AgriShield',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textOnLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().slideX(
            begin: 0.3,
            duration: 600.ms,
            curve: Curves.easeOut,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ProducerProfile profile) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'À propos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_isEditing)
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'Parlez-nous de vous, de votre exploitation, de vos méthodes...',
                border: OutlineInputBorder(),
              ),
            )
          else
            Text(
              profile.description?.isEmpty == true
                  ? 'Aucune description disponible'
                  : profile.description!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
        ],
      ),
    ).animate().slideY(begin: 0.2, duration: 700.ms, curve: Curves.easeOut);
  }

  Widget _buildDetailsSection(ProducerProfile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),

          // Email
          _buildDetailField(
            icon: Icons.email_outlined,
            label: 'Email',
            controller: _emailController,
            value: profile.email,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 12),

          // Téléphone
          _buildDetailField(
            icon: Icons.phone_outlined,
            label: 'Téléphone',
            controller: _phoneController,
            value: profile.phone,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 12),

          // Localisation
          _buildDetailField(
            icon: Icons.location_on_outlined,
            label: 'Localisation',
            controller: _locationController,
            value: profile.location ?? '',
          ),

          const SizedBox(height: 12),

          // Méthodes agricoles
          _buildDetailField(
            icon: Icons.agriculture_outlined,
            label: 'Méthodes agricoles',
            controller: _farmingMethodsController,
            value: profile.farmingMethods ?? '',
            maxLines: 2,
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, duration: 800.ms, curve: Curves.easeOut);
  }

  Widget _buildDetailField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String value,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              if (_isEditing)
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    hintText: 'Saisir $label',
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                )
              else
                Text(
                  value.isEmpty ? 'Non renseigné' : value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: value.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductionsHeader(ProducerProfile profile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.grass, color: AppColors.primaryGreen, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mes Productions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          if (profile.productions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${profile.productions.length}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    ).animate().slideX(begin: 0.3, duration: 900.ms, curve: Curves.easeOut);
  }

  Widget _buildProductionItem(Production production, int index) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ProductionCardWidget(
            production: production,
            onTap: () => _editProduction(production),
            onDelete: () => _deleteProduction(production.id),
          ),
        )
        .animate(delay: Duration(milliseconds: index * 100))
        .slideY(begin: 0.2, duration: 500.ms)
        .fadeIn(duration: 500.ms);
  }

  Widget _buildEmptyProductionsState() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Text('🌱', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune production',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez vos cultures pour valoriser votre travail',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateProfileState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_add,
              size: 64,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Créer votre profil',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Valorisez votre travail agricole\nen créant votre profil producteur',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _createProfile,
            icon: const Icon(Icons.add),
            label: const Text('Créer mon profil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryGreen),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.statusDanger,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.statusDanger),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                ref.read(producerProfileProvider.notifier).loadProfile(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  void _toggleEditMode(ProducerProfile? profile) {
    setState(() {
      _isEditing = true;
    });
    _initializeControllers(profile);
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _saveProfile(ProducerProfile? currentProfile) async {
    if (currentProfile == null) return;

    final updatedProfile = currentProfile.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      farmingMethods: _farmingMethodsController.text,
    );

    await ref
        .read(producerProfileProvider.notifier)
        .updateProfile(updatedProfile);

    setState(() {
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis à jour'),
          backgroundColor: AppColors.statusHealthy,
        ),
      );
    }
  }

  Future<void> _createProfile() async {
    final service = ref.read(producerProfileServiceProvider);
    final newProfile = service.createDefaultProfile();

    await ref.read(producerProfileProvider.notifier).createProfile(newProfile);

    setState(() {
      _isEditing = true;
    });
    _initializeControllers(newProfile);
  }

  Future<void> _updateProfilePhoto() async {
    await ref.read(producerProfileProvider.notifier).updateProfilePhoto();
  }

  bool _isProfileCompleted(ProducerProfile? profile) {
    if (profile == null) return false;

    // Le profil est considéré comme complété si :
    // - Le nom est renseigné
    // - La description est renseignée
    // - Au moins une production est ajoutée
    return profile.name.isNotEmpty &&
        profile.description?.isNotEmpty == true &&
        profile.productions.isNotEmpty;
  }

  Widget _buildClientFinderSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ClientFinderAnimation(
        onAnimationComplete: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Félicitations ! Un client potentiel s\'intéresse à vos produits.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF4CAF50),
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _addProduction() {
    showDialog(
      context: context,
      builder: (context) => ProductionFormDialog(
        onSave: (production) {
          ref.read(producerProfileProvider.notifier).addProduction(production);
        },
      ),
    );
  }

  void _editProduction(Production production) {
    showDialog(
      context: context,
      builder: (context) => ProductionFormDialog(
        production: production,
        onSave: (updatedProduction) {
          ref
              .read(producerProfileProvider.notifier)
              .updateProduction(updatedProduction);
        },
      ),
    );
  }

  void _deleteProduction(String productionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la production'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette production ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(producerProfileProvider.notifier)
                  .deleteProduction(productionId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusDanger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
