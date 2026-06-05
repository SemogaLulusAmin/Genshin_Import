import 'dart:typed_data' as typed_data;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:frontend/services/weapon_service.dart';
import 'package:frontend/view_models/user_viewmodel.dart';
import 'package:frontend/widgets/custom_form_field.dart';
import 'create_form.dart';

class CreateWeaponForm extends StatefulWidget {
  final bool isDark;

  const CreateWeaponForm({super.key, required this.isDark});

  @override
  State<CreateWeaponForm> createState() => _CreateWeaponFormState();
}

class _CreateWeaponFormState extends State<CreateWeaponForm> {
  final _formKey = GlobalKey<FormState>();

  typed_data.Uint8List? _imageBytes;
  XFile? _pickedFile;
  bool _isSubmitting = false;

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _rarityController = TextEditingController();
  final _attackController = TextEditingController();
  final _subStatController = TextEditingController();
  final _passiveNameController = TextEditingController();
  final _passiveDescController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _rarityController.dispose();
    _attackController.dispose();
    _subStatController.dispose();
    _passiveNameController.dispose();
    _passiveDescController.dispose();
    _priceController.dispose();
    _stockController.dispose();
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
      _showSnackBar("Please select a weapon image");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final fields = <String, String>{
        'name': _nameController.text.trim(),
        'type': _typeController.text.trim(),
        'rarity': _rarityController.text.trim(),
        'baseAttack': _attackController.text.trim(),
        'subStat': _subStatController.text.trim(),
        'passiveName': _passiveNameController.text.trim(),
        'passiveDesc': _passiveDescController.text.trim(),
        'price': _priceController.text.trim(),
        'stock': _stockController.text.trim(),
      };

      final success = await WeaponService().createWeapon(fields, _pickedFile!);

      if (success) {
        UserViewModel.instance.triggerInventoryRefresh();
        _resetForm();
        _showSnackBar("Weapon successfully created!");
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
    _typeController.clear();
    _rarityController.clear();
    _attackController.clear();
    _subStatController.clear();
    _passiveNameController.clear();
    _passiveDescController.clear();
    _priceController.clear();
    _stockController.clear();

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
          children: [
            CreateImagePicker(
              isDark: widget.isDark,
              imageBytes: _imageBytes,
              onTap: _pickImage,
            ),
            const SizedBox(height: 25),
            CustomFormField(
              label: "WEAPON NAME",
              hintText: "Enter weapon name",
              controller: _nameController,
              validator: (val) => val!.isEmpty ? "Required" : null,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    label: "TYPE",
                    hintText: "Enter weapon type",
                    controller: _typeController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormField(
                    label: "RARITY",
                    hintText: "Enter weapon rarity",
                    controller: _rarityController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    label: "BASE ATTACK",
                    hintText: "Enter weapon base attack",
                    controller: _attackController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormField(
                    label: "SUB STAT",
                    hintText: "Enter weapon sub stat",
                    controller: _subStatController,
                  ),
                ),
              ],
            ),
            CustomFormField(
              label: "PASSIVE NAME",
              hintText: "Enter the weapon's passive name",
              controller: _passiveNameController,
            ),
            CustomFormField(
              label: "PASSIVE DESCRIPTION",
              controller: _passiveDescController,
              hintText: "Enter the weapon's passive effect",
            ),
            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    label: "PRICE",
                    hintText: "Enter weapon price",
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFormField(
                    label: "STOCK",
                    hintText: "Enter weapon stock",
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CreateSubmitButton(isSubmitting: _isSubmitting, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
