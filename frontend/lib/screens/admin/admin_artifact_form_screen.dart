import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../models/artifact_model.dart';
import '../../services/artifact_service.dart';
import '../../core/app_colors.dart';

class AdminArtifactFormScreen extends StatefulWidget {
  final Artifact? artifact;

  const AdminArtifactFormScreen({super.key, this.artifact});

  @override
  State<AdminArtifactFormScreen> createState() => _AdminArtifactFormScreenState();
}

class _AdminArtifactFormScreenState extends State<AdminArtifactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setNameController = TextEditingController();
  final _maxRarityController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _bonus2Controller = TextEditingController();
  final _bonus4Controller = TextEditingController();
  PlatformFile? _pickedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.artifact != null) {
      final artifact = widget.artifact!;
      _nameController.text = artifact.name;
      _setNameController.text = artifact.setName;
      _maxRarityController.text = artifact.maxRarity;
      _priceController.text = artifact.price.toStringAsFixed(0);
      _stockController.text = artifact.stock.toString();
      _imageUrlController.text = artifact.imageUrl;
      _bonus2Controller.text = artifact.pieceBonus2 ?? '';
      _bonus4Controller.text = artifact.pieceBonus4 ?? '';
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
    _setNameController.dispose();
    _maxRarityController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _bonus2Controller.dispose();
    _bonus4Controller.dispose();
    super.dispose();
  }

  Future<void> _saveArtifact() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final setName = _setNameController.text.trim();
    final maxRarity = _maxRarityController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final imageUrl = _imageUrlController.text.trim();
    final bonus2 = _bonus2Controller.text.trim();
    final bonus4 = _bonus4Controller.text.trim();

    if (_pickedImage == null && imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image file or provide an image URL.')),
      );
      return;
    }

    final payload = {
      'name': name,
      'set_name': setName,
      'max_rarity': maxRarity,
      'price': price,
      'stock': stock,
      'image_url': imageUrl.isEmpty ? null : imageUrl,
      'piece_bonus_2': bonus2.isEmpty ? null : bonus2,
      'piece_bonus_4': bonus4.isEmpty ? null : bonus4,
    };

    setState(() => _isSaving = true);

    try {
      final service = ArtifactService();
      final success = widget.artifact == null
          ? await service.createArtifact(payload, imagePath: _pickedImage?.path)
          : await service.updateArtifact(widget.artifact!.artifactID, payload, imagePath: _pickedImage?.path);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.artifact == null
                ? 'Artifact created successfully.'
                : 'Artifact updated successfully.'),
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
    final title = widget.artifact == null ? 'New Artifact' : 'Edit Artifact';

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
              _buildField('Set Name', _setNameController),
              const SizedBox(height: 12),
              _buildField('Max Rarity', _maxRarityController,
                  hint: '3, 4, or 5'),
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
              const SizedBox(height: 12),
              _buildField('2-Piece Bonus', _bonus2Controller,
                  maxLines: 3),
              const SizedBox(height: 12),
              _buildField('4-Piece Bonus', _bonus4Controller,
                  maxLines: 3),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isSaving ? null : _saveArtifact,
                child: Text(
                  _isSaving
                      ? 'Saving...'
                      : widget.artifact == null
                          ? 'Create Artifact'
                          : 'Update Artifact',
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
