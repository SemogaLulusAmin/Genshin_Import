import 'dart:typed_data' as typed_data;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:frontend/core/app_colors.dart';
import 'package:frontend/services/artifact_service.dart';
import 'package:frontend/view_models/user_viewmodel.dart';
import 'package:frontend/widgets/custom_form_field.dart';
import 'create_form.dart';

class CreateArtifactForm extends StatefulWidget {
  final bool isDark;

  const CreateArtifactForm({super.key, required this.isDark});

  @override
  State<CreateArtifactForm> createState() => _CreateArtifactFormState();
}

class _CreateArtifactFormState extends State<CreateArtifactForm> {
  final _formKey = GlobalKey<FormState>();

  typed_data.Uint8List? _imageBytes;
  XFile? _pickedFile;
  bool _isSubmitting = false;

  final _nameController = TextEditingController();
  final _setController = TextEditingController();
  final _rarityController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  final _bonus2Controller = TextEditingController();
  final _bonus4Controller = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _setController.dispose();
    _rarityController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _bonus2Controller.dispose();
    _bonus4Controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image == null) return;

    final bytes = await image.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _pickedFile = image;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedFile == null) {
      _showSnackBar("Please select an artifact image");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final fields = <String, String>{
        'name': _nameController.text.trim(),
        'set_name': _setController.text.trim(),
        'max_rarity': _rarityController.text.trim(),
        'stock': _stockController.text.trim(),
        'price': _priceController.text.trim(),
        'piece_bonus_2': _bonus2Controller.text.trim(),
        'piece_bonus_4': _bonus4Controller.text.trim(),
      };

      final success = await ArtifactService().createArtifact(
        fields,
        _pickedFile!,
      );

      if (success) {
        UserViewModel.instance.triggerInventoryRefresh();
        _resetForm();
        _showSnackBar("Artifact successfully created!");
      }
    } catch (e) {
      _showSnackBar(e.toString().replaceAll("Exception: ", ""), isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _setController.clear();
    _rarityController.clear();
    _stockController.clear();
    _priceController.clear();
    _bonus2Controller.clear();
    _bonus4Controller.clear();

    if (!mounted) return;
    setState(() {
      _imageBytes = null;
      _pickedFile = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CreateFormScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateImagePicker(
              isDark: widget.isDark,
              imageBytes: _imageBytes,
              onTap: _pickImage,
            ),
            const SizedBox(height: 25),
            CustomFormField(
              label: "ARTIFACT NAME",
              controller: _nameController,
              hintText: "Enter artifact name",
              validator: (val) => val!.isEmpty ? "Name is required" : null,
            ),
            CustomFormField(
              label: "SET NAME",
              controller: _setController,
              hintText: "Enter artifact set name",
              validator: (val) => val!.isEmpty ? "Set name is required" : null,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    label: "MAX RARITY",
                    hintText: "Enter max artifact rarity",
                    controller: _rarityController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormField(
                    label: "STOCK",
                    hintText: "Enter artifact stock",
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            CustomFormField(
              label: "PRICE ",
              hintText: "Enter artifact price",
              controller: _priceController,
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty ? "Price is required" : null,
            ),
            const SizedBox(height: 9),
            const Text(
              "SET BONUSES",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            CustomFormField(
              label: "2-PIECE BONUS",
              controller: _bonus2Controller,
              hintText: "Effect when wearing 2 pieces",
              validator: (val) => val!.isEmpty ? "Bonus is required" : null,
            ),
            CustomFormField(
              label: "4-PIECE BONUS",
              controller: _bonus4Controller,
              hintText: "Effect when wearing 4 pieces",
              validator: (val) => val!.isEmpty ? "Bonus is required" : null,
            ),
            const SizedBox(height: 24),
            CreateSubmitButton(isSubmitting: _isSubmitting, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
