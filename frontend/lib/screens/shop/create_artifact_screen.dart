import 'dart:convert';
import 'dart:typed_data' as typed_data;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_colors.dart';
import '../../services/artifact_service.dart';
import '../../view_models/user_viewmodel.dart';
import '../../widgets/custom_form_field.dart';

class CreateArtifactScreen extends StatefulWidget {
  const CreateArtifactScreen({super.key});

  @override
  State<CreateArtifactScreen> createState() => _CreateArtifactScreenState();
}

class _CreateArtifactScreenState extends State<CreateArtifactScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use Uint8List for the UI preview and XFile for the Service upload
  typed_data.Uint8List? _imageBytes;
  XFile? _pickedFile;
  bool _isSubmitting = false;

  // Controllers matching your Backend req.body
  final _nameController = TextEditingController();
  final _setController = TextEditingController();
  final _rarityController = TextEditingController(text: "5");
  final _stockController = TextEditingController(text: "99");
  final _priceController = TextEditingController();
  final _bonus2Controller = TextEditingController();
  final _bonus4Controller = TextEditingController();

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
    // 1. Validate Form fields
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
      // 3. Map fields
      final Map<String, String> fields = {
        'name': _nameController.text.trim(),
        'set_name': _setController.text.trim(),
        'max_rarity': _rarityController.text.trim(),
        'stock': _stockController.text.trim(),
        'price': _priceController.text.trim(),
        'piece_bonus_2': _bonus2Controller.text.trim(),
        'piece_bonus_4': _bonus4Controller.text.trim(),
      };

      // 4. Call the Service
      final success = await ArtifactService().createArtifact(fields, _pickedFile!);

      if (success) {
        UserViewModel.instance.triggerInventoryRefresh();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Artifact successfully created!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : Colors.white,
      appBar: AppBar(
        title: const Text("CREATE AN ARTIFACT",
            style: TextStyle(fontFamily: "HyWenhei", letterSpacing: 1.2)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(isDark),
              const SizedBox(height: 25),
              CustomFormField(
                label: "ARTIFACT NAME",
                controller: _nameController,
                hintText: "Enter artifact name...",
                validator: (val) => val!.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: "SET NAME",
                controller: _setController,
                hintText: "e.g. Viridescent Venerer",
                validator: (val) => val!.isEmpty ? "Set name is required" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      label: "MAX RARITY",
                      controller: _rarityController,
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
              const SizedBox(height: 16),
              CustomFormField(
                label: "PRICE (MORA)",
                controller: _priceController,
                keyboardType: TextInputType.number,
                hintText: "0",
                validator: (val) => val!.isEmpty ? "Price is required" : null,
              ),
              const SizedBox(height: 25),
              const Text("SET BONUSES",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 10),
              CustomFormField(
                label: "2-PIECE BONUS",
                controller: _bonus2Controller,
                hintText: "Effect when wearing 2 pieces...",
                validator: (val) => val!.isEmpty ? "Bonus is required" : null,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: "4-PIECE BONUS",
                controller: _bonus4Controller,
                hintText: "Effect when wearing 4 pieces...",
                validator: (val) => val!.isEmpty ? "Bonus is required" : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("CONFIRM CREATE",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                ),
              ),
            ],
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
                  Icon(Icons.add_a_photo_outlined,
                      color: AppColors.primary, size: 40),
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