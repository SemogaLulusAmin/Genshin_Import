import 'dart:io';
<<<<<<< HEAD

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../models/weapon_model.dart';
import '../../services/weapon_service.dart';
import '../../core/app_colors.dart';
=======
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/weapon_model.dart';
import '../../services/weapon_service.dart';
import '../../services/auth_service.dart';
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9

class AdminWeaponFormScreen extends StatefulWidget {
  final Weapon? weapon;

  const AdminWeaponFormScreen({super.key, this.weapon});

  @override
  State<AdminWeaponFormScreen> createState() => _AdminWeaponFormScreenState();
}

class _AdminWeaponFormScreenState extends State<AdminWeaponFormScreen> {
  final _formKey = GlobalKey<FormState>();
<<<<<<< HEAD
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
=======
  final WeaponService _weaponService = WeaponService();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _rarityController = TextEditingController();
  final TextEditingController _baseAttackController = TextEditingController();
  final TextEditingController _subStatController = TextEditingController();
  final TextEditingController _passiveNameController = TextEditingController();
  final TextEditingController _passiveDescController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  bool? _isAdmin;
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
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
=======
    _checkAdminAccess();
    if (widget.weapon != null) {
      _nameController.text = widget.weapon!.name;
      _typeController.text = widget.weapon!.type;
      _rarityController.text = widget.weapon!.rarity;
      _baseAttackController.text = widget.weapon!.baseAttack;
      _subStatController.text = widget.weapon!.subStat;
      _passiveNameController.text = widget.weapon!.passiveName;
      _passiveDescController.text = widget.weapon!.passiveDesc;
      _priceController.text = widget.weapon!.price.toString();
      _stockController.text = widget.weapon!.stock.toString();
    }
  }

  Future<void> _checkAdminAccess() async {
    final isAdmin = await _authService.isAdmin();
    if (!isAdmin && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Access denied. Admin privileges required.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _isAdmin = isAdmin;
    });
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
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
<<<<<<< HEAD
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
=======
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveWeapon() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null && widget.weapon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
      );
      return;
    }

<<<<<<< HEAD
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
=======
    setState(() => _isLoading = true);

    try {
      final weaponData = {
        'name': _nameController.text,
        'type': _typeController.text,
        'rarity': _rarityController.text,
        'baseAttack': _baseAttackController.text,
        'subStat': _subStatController.text,
        'passiveName': _passiveNameController.text,
        'passiveDesc': _passiveDescController.text,
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
      };

      bool success;
      if (widget.weapon == null) {
        // Create new weapon
        success = await _weaponService.createWeapon(weaponData, _imageFile!.path);
      } else {
        // Update existing weapon
        success = await _weaponService.updateWeapon(
          widget.weapon!.weaponID,
          weaponData,
          _imageFile?.path,
        );
      }

      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving weapon: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    if (_isAdmin == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isAdmin != true) {
      return const Scaffold(
        body: Center(child: Text('Access denied')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.weapon == null ? 'Add Weapon' : 'Edit Weapon'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : widget.weapon != null && widget.weapon!.imageUrl.isNotEmpty
                                ? Image.network(
                                    'http://localhost:3000${widget.weapon!.imageUrl}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.add_a_photo, size: 50),
                                  )
                                : const Icon(Icons.add_a_photo, size: 50),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Form fields
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(labelText: 'Type'),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _rarityController,
                      decoration: const InputDecoration(labelText: 'Rarity'),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _baseAttackController,
                      decoration: const InputDecoration(labelText: 'Base Attack'),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _subStatController,
                      decoration: const InputDecoration(labelText: 'Sub Stat'),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passiveNameController,
                      decoration: const InputDecoration(labelText: 'Passive Name'),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passiveDescController,
                      decoration: const InputDecoration(labelText: 'Passive Description'),
                      maxLines: 3,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        if (double.tryParse(value!) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        if (int.tryParse(value!) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _saveWeapon,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(widget.weapon == null ? 'Add Weapon' : 'Update Weapon'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
>>>>>>> 8a977c133c93a5f80c07f5726b46251369f739a9
