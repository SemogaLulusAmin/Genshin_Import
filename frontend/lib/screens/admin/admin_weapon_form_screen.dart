import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../models/weapon_model.dart';
import '../../services/weapon_service.dart';
import '../../core/app_colors.dart';

class AdminWeaponFormScreen extends StatefulWidget {
  final Weapon? weapon;

  const AdminWeaponFormScreen({super.key, this.weapon});

  @override
  State<AdminWeaponFormScreen> createState() => _AdminWeaponFormScreenState();
}

class _AdminWeaponFormScreenState extends State<AdminWeaponFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _rarityController = TextEditingController();
  final _baseAttackController = TextEditingController();
  final _subStatController = TextEditingController();
  final _passiveNameController = TextEditingController();
  final _passiveDescController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  PlatformFile? _pickedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.weapon != null) {
      final weapon = widget.weapon!;
      _nameController.text = weapon.name;
      _typeController.text = weapon.type;
      _rarityController.text = weapon.rarity;
      _baseAttackController.text = weapon.baseAttack;
      _subStatController.text = weapon.subStat;
      _passiveNameController.text = weapon.passiveName;
      _passiveDescController.text = weapon.passiveDesc;
      _priceController.text = weapon.price.toStringAsFixed(0);
      _stockController.text = weapon.stock.toString();
      _imageUrlController.text = weapon.imageUrl;
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedImage = result.files.first;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _rarityController.dispose();
    _baseAttackController.dispose();
    _subStatController.dispose();
    _passiveNameController.dispose();
    _passiveDescController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveWeapon() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final type = _typeController.text.trim();
    final rarity = _rarityController.text.trim();
    final baseAttack = _baseAttackController.text.trim();
    final subStat = _subStatController.text.trim();
    final passiveName = _passiveNameController.text.trim();
    final passiveDesc = _passiveDescController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;

    if (_pickedImage == null && imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image file or provide an image URL.')),
      );
      return;
    }

    final payload = {
      'name': name,
      'type': type,
      'rarity': rarity,
      'baseAttack': baseAttack,
      'subStat': subStat,
      'passiveName': passiveName,
      'passiveDesc': passiveDesc,
      'price': price,
      'stock': stock,
      'image_url': imageUrl.isEmpty ? null : imageUrl,
    };

    setState(() => _isSaving = true);

    try {
      final service = WeaponService();
      final success = widget.weapon == null
          ? await service.createWeapon(payload, imagePath: _pickedImage?.path)
          : await service.updateWeapon(widget.weapon!.weaponID, payload, imagePath: _pickedImage?.path);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.weapon == null
                ? 'Weapon created successfully.'
                : 'Weapon updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        if (context.mounted) Navigator.of(context).pop(true);
        return;
      }

      throw Exception('Server rejected request');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.weapon == null ? 'New Weapon' : 'Edit Weapon';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField('Name', _nameController),
              const SizedBox(height: 12),
              _buildField('Type', _typeController),
              const SizedBox(height: 12),
              _buildField('Rarity', _rarityController,
                  hint: '3, 4, or 5'),
              const SizedBox(height: 12),
              _buildField('Base Attack', _baseAttackController),
              const SizedBox(height: 12),
              _buildField('Sub Stat', _subStatController),
              const SizedBox(height: 12),
              _buildField('Passive Name', _passiveNameController),
              const SizedBox(height: 12),
              _buildField('Passive Desc', _passiveDescController,
                  maxLines: 4),
              const SizedBox(height: 12),
              _buildField('Price', _priceController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildField('Stock', _stockController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildField('Image URL', _imageUrlController),
              const SizedBox(height: 12),
              _buildImagePicker(),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isSaving ? null : _saveWeapon,
                child: Text(
                  _isSaving
                      ? 'Saving...'
                      : widget.weapon == null
                          ? 'Create Weapon'
                          : 'Update Weapon',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        if (_pickedImage != null && _pickedImage!.path != null)
          SizedBox(
            height: 150,
            child: Image.file(File(_pickedImage!.path!), fit: BoxFit.cover),
          )
        else if (_imageUrlController.text.isNotEmpty)
          SizedBox(
            height: 150,
            child: Image.network(
              _imageUrlController.text,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(child: Text('Invalid or missing URL')),
            ),
          )
        else
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Select a local image or enter an image URL')),
          ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: const Icon(Icons.upload_file),
          label: const Text('Select Image File'),
          onPressed: _pickImage,
        ),
        if (_pickedImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Selected: ${_pickedImage!.name}'),
          ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
