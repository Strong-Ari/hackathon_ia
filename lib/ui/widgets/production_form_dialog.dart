import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/producer_profile_model.dart';
import '../../core/providers/producer_profile_service.dart';

class ProductionFormDialog extends ConsumerStatefulWidget {
  final Production? production;
  final Function(Production) onSave;

  const ProductionFormDialog({
    super.key,
    this.production,
    required this.onSave,
  });

  @override
  ConsumerState<ProductionFormDialog> createState() => _ProductionFormDialogState();
}

class _ProductionFormDialogState extends ConsumerState<ProductionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _seasonController;
  late TextEditingController _yieldController;
  late TextEditingController _yieldUnitController;
  late TextEditingController _notesController;
  
  DateTime? _plantingDate;
  DateTime? _harvestDate;
  ProductionStatus _status = ProductionStatus.active;
  List<String> _photos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    final production = widget.production;
    _nameController = TextEditingController(text: production?.name ?? '');
    _seasonController = TextEditingController(text: production?.season ?? '');
    _yieldController = TextEditingController(
      text: production?.estimatedYield?.toString() ?? '',
    );
    _yieldUnitController = TextEditingController(text: production?.yieldUnit ?? 'kg');
    _notesController = TextEditingController(text: production?.notes ?? '');
    
    if (production != null) {
      _plantingDate = production.plantingDate;
      _harvestDate = production.harvestDate;
      _status = production.status;
      _photos = List.from(production.photos);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _seasonController.dispose();
    _yieldController.dispose();
    _yieldUnitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight - keyboardHeight - 100; // 100px de marge

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: maxHeight,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            
            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom de la culture
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nom de la culture',
                        icon: Icons.grass,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Veuillez saisir le nom de la culture';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Saison
                      _buildTextField(
                        controller: _seasonController,
                        label: 'Saison (optionnel)',
                        icon: Icons.calendar_today,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Statut
                      _buildStatusSelector(),
                      
                      const SizedBox(height: 16),
                      
                      // Dates
                      _buildDateFields(),
                      
                      const SizedBox(height: 16),
                      
                      // Rendement
                      _buildYieldFields(),
                      
                      const SizedBox(height: 16),
                      
                      // Photos
                      _buildPhotoSection(),
                      
                      const SizedBox(height: 16),
                      
                      // Notes
                      _buildTextField(
                        controller: _notesController,
                        label: 'Notes (optionnel)',
                        icon: Icons.note,
                        maxLines: 3,
                      ),
                      
                      // Espacement supplémentaire pour éviter le débordement
                      SizedBox(height: keyboardHeight > 0 ? 20 : 0),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer avec boutons
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.agriculture,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.production == null ? 'Nouvelle production' : 'Modifier la production',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.timeline, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Text(
              'Statut',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ProductionStatus.values.map((status) {
            final isSelected = _status == status;
            return FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(status.icon),
                  const SizedBox(width: 4),
                  Text(status.displayName),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  _status = status;
                });
              },
              selectedColor: AppColors.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppColors.primaryGreen,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            label: 'Date de plantation',
            icon: Icons.event_available,
            date: _plantingDate,
            onTap: () => _selectDate(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDateField(
            label: 'Date de récolte',
            icon: Icons.agriculture,
            date: _harvestDate,
            onTap: () => _selectDate(false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primaryGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Sélectionner',
          style: TextStyle(
            color: date != null ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildYieldFields() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildTextField(
            controller: _yieldController,
            label: 'Rendement estimé',
            icon: Icons.straighten,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextField(
            controller: _yieldUnitController,
            label: 'Unité',
            icon: Icons.scale,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_library, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Text(
              'Photos (${_photos.length})',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addPhoto,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Ajouter'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_photos.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return _buildPhotoItem(_photos[index], index);
              },
            ),
          )
        else
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera,
                  color: AppColors.primaryGreen,
                  size: 32,
                ),
                SizedBox(height: 4),
                Text(
                  'Aucune photo ajoutée',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPhotoItem(String photoPath, int index) {
    return Container(
      margin: EdgeInsets.only(right: index < _photos.length - 1 ? 8 : 0),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(photoPath),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.primaryGreen,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removePhoto(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.statusDanger,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProduction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(widget.production == null ? 'Créer' : 'Modifier'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isPlantingDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPlantingDate) {
          _plantingDate = picked;
        } else {
          _harvestDate = picked;
        }
      });
    }
  }

  Future<void> _addPhoto() async {
    try {
      final service = ref.read(producerProfileServiceProvider);
      
      // Afficher un dialogue pour choisir entre galerie et caméra
      final String? photoPath = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ajouter une photo'),
          content: const Text('Choisissez la source de votre photo'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final path = await service.pickAndSaveProductionPhoto();
                if (path != null && mounted) {
                  Navigator.of(context).pop(path);
                }
              },
              child: const Text('Galerie'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final path = await service.takePhoto();
                if (path != null && mounted) {
                  Navigator.of(context).pop(path);
                }
              },
              child: const Text('Caméra'),
            ),
          ],
        ),
      );

      if (photoPath != null) {
        setState(() {
          _photos.add(photoPath);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout de la photo: $e'),
            backgroundColor: AppColors.statusDanger,
          ),
        );
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  Future<void> _saveProduction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final production = Production(
        id: widget.production?.id ?? 'production_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        season: _seasonController.text.isEmpty ? null : _seasonController.text,
        plantingDate: _plantingDate,
        harvestDate: _harvestDate,
        estimatedYield: _yieldController.text.isEmpty 
            ? null 
            : double.tryParse(_yieldController.text),
        yieldUnit: _yieldUnitController.text.isEmpty ? null : _yieldUnitController.text,
        photos: _photos,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        status: _status,
      );

      widget.onSave(production);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.production == null 
                  ? 'Production créée avec succès' 
                  : 'Production modifiée avec succès',
            ),
            backgroundColor: AppColors.statusHealthy,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde: $e'),
            backgroundColor: AppColors.statusDanger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}