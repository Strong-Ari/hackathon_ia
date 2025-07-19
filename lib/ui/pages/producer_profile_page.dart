import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../core/constants/app_colors.dart';
import '../../core/models/producer_profile.dart';
import '../../core/providers/producer_profile_provider.dart';
import '../widgets/producer_bottom_nav.dart';

class ProducerProfilePage extends ConsumerStatefulWidget {
  const ProducerProfilePage({super.key});

  @override
  ConsumerState<ProducerProfilePage> createState() => _ProducerProfilePageState();
}

class _ProducerProfilePageState extends ConsumerState<ProducerProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(producerProfileProvider);

    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Mettre à jour les contrôleurs quand le profil change
    if (!_isEditing) {
      _nameController.text = profile.fullName;
      _descriptionController.text = profile.description;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(profile),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileInfo(profile),
                  const SizedBox(height: 24),
                  _buildProductionsSection(profile),
                  const SizedBox(height: 100), // Espace pour la bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ProducerBottomNav(currentIndex: 2),
    );
  }

  Widget _buildSliverAppBar(ProducerProfile profile) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryGreen,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(_isEditing ? PhosphorIcons.check : PhosphorIcons.pencil,
              color: Colors.white),
          onPressed: () => _toggleEditing(profile),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryGreen,
                Color(0xFF2E7D32),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              _buildProfileAvatar(profile),
              const SizedBox(height: 16),
              Text(
                profile.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 300))
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 8),
              const Text(
                'Producteur Bio Certifié',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 500))
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(ProducerProfile profile) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 46,
            backgroundColor: Colors.white,
            backgroundImage: profile.profileImageUrl != null
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            child: profile.profileImageUrl == null
                ? const Icon(
                    PhosphorIcons.user,
                    size: 50,
                    color: AppColors.primaryGreen,
                  )
                : null,
          ),
        )
            .animate()
            .scale(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
            )
            .fadeIn(),
        if (_isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(PhosphorIcons.camera, size: 16),
                onPressed: _pickImage,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileInfo(ProducerProfile profile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(PhosphorIcons.user, color: AppColors.primaryGreen),
                  const SizedBox(width: 12),
                  Text(
                    'Informations personnelles',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Nom complet
              TextFormField(
                controller: _nameController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: const Icon(PhosphorIcons.identification),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                enabled: _isEditing,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Présentation',
                  prefixIcon: const Icon(PhosphorIcons.textAlignLeft),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La présentation est requise';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildProductionsSection(ProducerProfile profile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(PhosphorIcons.plant, color: AppColors.primaryGreen),
                    const SizedBox(width: 12),
                    Text(
                      'Productions agricoles',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(PhosphorIcons.plus, color: AppColors.primaryGreen),
                    onPressed: () => _showAddProductionDialog(profile),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (profile.productions.isEmpty)
              _buildEmptyProductions()
            else
              ...profile.productions.asMap().entries.map((entry) {
                final index = entry.key;
                final production = entry.value;
                return _buildProductionCard(production, index, profile);
              }),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 600))
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildEmptyProductions() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            PhosphorIcons.plant,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune production',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez vos productions pour compléter votre profil',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionCard(ProductionItem production, int index, ProducerProfile profile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getStatusColor(production.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(production.status),
                color: _getStatusColor(production.status),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    production.type,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${production.quantity} • ${production.season}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(production.status),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      production.status.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            if (_isEditing)
              PopupMenuButton(
                icon: const Icon(PhosphorIcons.dotsThreeVertical),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(PhosphorIcons.pencil, size: 16),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                    onTap: () => _showEditProductionDialog(production, profile),
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(PhosphorIcons.trash, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    onTap: () => _removeProduction(production.id),
                  ),
                ],
              ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 200 + (index * 100)))
        .slideX(begin: 1.0, end: 0.0);
  }

  Color _getStatusColor(ProductionStatus status) {
    switch (status) {
      case ProductionStatus.enStock:
        return Colors.green;
      case ProductionStatus.vendu:
        return Colors.blue;
      case ProductionStatus.enCroissance:
        return Colors.orange;
      case ProductionStatus.recolte:
        return Colors.purple;
    }
  }

  IconData _getStatusIcon(ProductionStatus status) {
    switch (status) {
      case ProductionStatus.enStock:
        return PhosphorIcons.package;
      case ProductionStatus.vendu:
        return PhosphorIcons.handshake;
      case ProductionStatus.enCroissance:
        return PhosphorIcons.plant;
      case ProductionStatus.recolte:
        return PhosphorIcons.basket;
    }
  }

  void _toggleEditing(ProducerProfile profile) {
    if (_isEditing) {
      // Sauvegarder les modifications
      if (_formKey.currentState!.validate()) {
        ref.read(producerProfileProvider.notifier).updateBasicInfo(
              fullName: _nameController.text,
              description: _descriptionController.text,
            );
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // Ici, vous pourriez uploader l'image vers un serveur
      // Pour cet exemple, on simule juste la mise à jour
      ref.read(producerProfileProvider.notifier).updateBasicInfo(
            profileImageUrl: image.path, // En réalité, ce serait une URL
          );
    }
  }

  void _showAddProductionDialog(ProducerProfile profile) {
    _showProductionDialog(null, profile);
  }

  void _showEditProductionDialog(ProductionItem production, ProducerProfile profile) {
    _showProductionDialog(production, profile);
  }

  void _showProductionDialog(ProductionItem? production, ProducerProfile profile) {
    final typeController = TextEditingController(text: production?.type ?? '');
    final quantityController = TextEditingController(text: production?.quantity ?? '');
    final seasonController = TextEditingController(text: production?.season ?? '');
    ProductionStatus selectedStatus = production?.status ?? ProductionStatus.enCroissance;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(production == null ? 'Ajouter une production' : 'Modifier la production'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Type de culture',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantité moyenne',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: seasonController,
                decoration: const InputDecoration(
                  labelText: 'Saison',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) => DropdownButtonFormField<ProductionStatus>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Statut',
                    border: OutlineInputBorder(),
                  ),
                  items: ProductionStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newProduction = ProductionItem(
                id: production?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                type: typeController.text,
                quantity: quantityController.text,
                season: seasonController.text,
                status: selectedStatus,
              );

              if (production == null) {
                ref.read(producerProfileProvider.notifier).addProduction(newProduction);
              } else {
                ref.read(producerProfileProvider.notifier).updateProduction(newProduction);
              }

              Navigator.of(context).pop();
            },
            child: Text(production == null ? 'Ajouter' : 'Modifier'),
          ),
        ],
      ),
    );
  }

  void _removeProduction(String productionId) {
    ref.read(producerProfileProvider.notifier).removeProduction(productionId);
  }
}