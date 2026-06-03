import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_input_field.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/artifact_model.dart';
import '../../services/artifact_service.dart';

class ArtifactEditScreen extends StatefulWidget {
  final Artifact artifact;
  const ArtifactEditScreen({super.key, required this.artifact});

  @override
  State<ArtifactEditScreen> createState() => _ArtifactEditScreenState();
}

class _ArtifactEditScreenState extends State<ArtifactEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController setController;
  late TextEditingController rarityController;
  late TextEditingController stockController;
  late TextEditingController priceController;
  late TextEditingController bonus2Controller;
  late TextEditingController bonus4Controller;

  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.artifact.name);
    setController = TextEditingController(text: widget.artifact.setName);
    rarityController = TextEditingController(text: widget.artifact.maxRarity);
    stockController = TextEditingController(
      text: widget.artifact.stock.toString(),
    );
    priceController = TextEditingController(
      text: widget.artifact.price.toString(),
    );
    bonus2Controller = TextEditingController(text: widget.artifact.pieceBonus2);
    bonus4Controller = TextEditingController(text: widget.artifact.pieceBonus4);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _selectedImage = image);
  }

  void _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final fields = {
      'name': nameController.text,
      'set_name': setController.text,
      'max_rarity': rarityController.text,
      'stock': stockController.text,
      'price': priceController.text,
      'piece_bonus_2': bonus2Controller.text,
      'piece_bonus_4': bonus4Controller.text,
    };

    try {
      final success = await ArtifactService().updateArtifact(
        widget.artifact.artifactID,
        fields,
        imageFile: _selectedImage,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Updated!")));
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Artifact")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_selectedImage != null)
              Image.network(_selectedImage!.path, height: 100)
            else
              Image.network(widget.artifact.imageUrl, height: 100),

            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Change Image (Optional)"),
            ),

            CustomInputField(
              label: 'Artifact Name',
              hintText: 'Artifact Name',
              controller: nameController,
            ),

            CustomInputField(
              label: 'Set Name',
              hintText: 'Set Name',
              controller: setController,
            ),

            CustomInputField(
              label: 'Max Rarity',
              hintText: 'Max Rarity',
              controller: rarityController,
            ),

            CustomInputField(
              label: 'Stock',
              hintText: 'Stock',
              controller: stockController,
              keyboardType: TextInputType.number,
            ),

            CustomInputField(
              label: 'Price',
              hintText: 'Price',
              controller: priceController,
              keyboardType: TextInputType.number,
            ),

            CustomInputField(
              label: '2-Piece Bonus',
              hintText: 'The effect',
              controller: bonus2Controller,
            ),

            CustomInputField(
              label: '4-Piece Bonus',
              hintText: 'The effect',
              controller: bonus4Controller,
            ),

            const SizedBox(height: 20),

            CustomButton(text: 'Save Changes', onPressed: _submitUpdate),
          ],
        ),
      ),
    );
  }
}
