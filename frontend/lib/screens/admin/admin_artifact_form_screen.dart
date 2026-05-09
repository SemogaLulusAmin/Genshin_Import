import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/artifact_model.dart';
import '../../services/artifact_service.dart';
import '../../services/auth_service.dart';

class AdminArtifactFormScreen extends StatefulWidget {
  final Artifact? artifact;

  const AdminArtifactFormScreen({super.key, this.artifact});

  @override
  State<AdminArtifactFormScreen> createState() => _AdminArtifactFormScreenState();
}

class _AdminArtifactFormScreenState extends State<AdminArtifactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ArtifactService _artifactService = ArtifactService();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _setNameController = TextEditingController();
  final TextEditingController _maxRarityController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _pieceBonus2Controller = TextEditingController();
  final TextEditingController _pieceBonus4Controller = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  bool? _isAdmin;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
    if (widget.artifact != null) {
      _nameController.text = widget.artifact!.name;
      _setNameController.text = widget.artifact!.setName;
      _maxRarityController.text = widget.artifact!.maxRarity;
      _stockController.text = widget.artifact!.stock.toString();
      _priceController.text = widget.artifact!.price.toString();
      _pieceBonus2Controller.text = widget.artifact!.pieceBonus2 ?? '';
      _pieceBonus4Controller.text = widget.artifact!.pieceBonus4 ?? '';
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
    _setNameController.dispose();
    _maxRarityController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _pieceBonus2Controller.dispose();
    _pieceBonus4Controller.dispose();
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

  Future<void> _saveArtifact() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null && widget.artifact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final artifactData = {
        'name': _nameController.text,
        'set_name': _setNameController.text,
        'max_rarity': _maxRarityController.text,
        'stock': int.parse(_stockController.text),
        'price': double.parse(_priceController.text),
        'piece_bonus_2': _pieceBonus2Controller.text.isEmpty ? null : _pieceBonus2Controller.text,
        'piece_bonus_4': _pieceBonus4Controller.text.isEmpty ? null : _pieceBonus4Controller.text,
      };

      bool success;
      if (widget.artifact == null) {
        // Create new artifact
        success = await _artifactService.createArtifact(artifactData, _imageFile!.path);
      } else {
        // Update existing artifact
        success = await _artifactService.updateArtifact(
          widget.artifact!.artifactID,
          artifactData,
          _imageFile?.path,
        );
      }

      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving artifact: $e')),
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
        title: Text(widget.artifact == null ? 'Add Artifact' : 'Edit Artifact'),
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
                            : widget.artifact != null && widget.artifact!.imageUrl.isNotEmpty
                                ? Image.network(
                                    'http://localhost:3000${widget.artifact!.imageUrl}',
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
                      controller: _setNameController,
                      decoration: const InputDecoration(labelText: 'Set Name'),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _maxRarityController,
                      decoration: const InputDecoration(labelText: 'Max Rarity'),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
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
                      controller: _pieceBonus2Controller,
                      decoration: const InputDecoration(labelText: '2-Piece Bonus (Optional)'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _pieceBonus4Controller,
                      decoration: const InputDecoration(labelText: '4-Piece Bonus (Optional)'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _saveArtifact,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(widget.artifact == null ? 'Add Artifact' : 'Update Artifact'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}