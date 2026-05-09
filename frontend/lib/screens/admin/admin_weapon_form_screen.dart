import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/weapon_model.dart';
import '../../services/weapon_service.dart';
import '../../services/auth_service.dart';

class AdminWeaponFormScreen extends StatefulWidget {
  final Weapon? weapon;

  const AdminWeaponFormScreen({super.key, this.weapon});

  @override
  State<AdminWeaponFormScreen> createState() => _AdminWeaponFormScreenState();
}

class _AdminWeaponFormScreenState extends State<AdminWeaponFormScreen> {
  final _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    super.initState();
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
      );
      return;
    }

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
    }
  }

  @override
  Widget build(BuildContext context) {
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