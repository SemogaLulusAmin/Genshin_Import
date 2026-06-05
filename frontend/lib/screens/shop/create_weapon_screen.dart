import 'dart:typed_data' as typed_data;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_colors.dart';
import '../../services/weapon_service.dart';
import '../../view_models/user_viewmodel.dart';
import '../../widgets/custom_form_field.dart';

class CreateWeaponScreen extends StatefulWidget {
  const CreateWeaponScreen({super.key});

  @override
  State<CreateWeaponScreen> createState() => _CreateWeaponScreenState();
}

class _CreateWeaponScreenState extends State<CreateWeaponScreen> {
  final _formKey = GlobalKey<FormState>();

  typed_data.Uint8List? _imageBytes;
  XFile? _pickedFile;
  bool _isSubmitting = false;

  // Controllers matching your Backend req.body exactly
  final _nameController = TextEditingController();
  final _typeController = TextEditingController(text: "Sword");
  final _rarityController = TextEditingController(text: "5");
  final _attackController = TextEditingController();
  final _subStatController = TextEditingController();
  final _passiveNameController = TextEditingController();
  final _passiveDescController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: "99");

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // 1. Pick the image from gallery
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      // 2. Read as bytes (Corrected variable name)
      final typed_data.Uint8List bytes = await image.readAsBytes();

      // 3. Update state
      setState(() {
        _imageBytes = bytes;
        _pickedFile = image;
      });
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    // 2. Check if an image has been picked
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an artifact image")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 1. Map fields EXACTLY to your Backend's req.body keys
      final Map<String, String> fields = {
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

      // 2. Call the WeaponService (Connected to Backend)
      final success = await WeaponService().createWeapon(fields, _pickedFile!);

      if (success) {
        UserViewModel.instance.triggerInventoryRefresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Weapon successfully created!")),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding =
        MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).viewInsets.bottom +
        24;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text(
          "CREATE WEAPON",
          style: TextStyle(fontFamily: "HyWenhei"),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildImagePicker(isDark),
                const SizedBox(height: 25),

                CustomFormField(
                  label: "WEAPON NAME",
                  controller: _nameController,
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomFormField(
                        label: "TYPE",
                        controller: _typeController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomFormField(
                        label: "RARITY",
                        controller: _rarityController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomFormField(
                        label: "BASE ATTACK",
                        controller: _attackController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomFormField(
                        label: "SUB STAT",
                        controller: _subStatController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CustomFormField(
                  label: "PASSIVE NAME",
                  controller: _passiveNameController,
                ),
                const SizedBox(height: 16),

                CustomFormField(
                  label: "PASSIVE DESCRIPTION",
                  controller: _passiveDescController,
                  hintText: "Enter the weapon's passive effect...",
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomFormField(
                        label: "PRICE",
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomFormField(
                        label: "STOCK",
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(
                            color: AppColors.textPrimaryDark,
                          )
                        : const Text(
                            "CONFIRM CREATE",
                            style: TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(bool isDark) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.fieldBackgroundDark
              : AppColors.fieldBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: _imageBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(_imageBytes!, fit: BoxFit.contain),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColors.primary,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "UPLOAD IMAGE",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
