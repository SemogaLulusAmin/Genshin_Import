import 'package:flutter/material.dart';
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
  
  // Controller diisi pake data artifact yang mau diedit (Auto-fill)
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
    stockController = TextEditingController(text: widget.artifact.stock.toString());
    priceController = TextEditingController(text: widget.artifact.price.toString());
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

    // Data yang dikirim harus sama kayak destructuring di backend lu
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
        imageFile: _selectedImage, // Ini opsional, kalau kosong backend lu pake image lama
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated!")));
        Navigator.pop(context, true); // Balik sambil kasih info sukses
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
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
               Image.network(_selectedImage!.path, height: 100) // Preview image baru (Web)
            else 
               Image.network(widget.artifact.imageUrl, height: 100), // Preview image lama
            
            TextButton.icon(
              onPressed: _pickImage, 
              icon: const Icon(Icons.image), 
              label: const Text("Change Image (Optional)")
            ),
            
            TextFormField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextFormField(controller: setController, decoration: const InputDecoration(labelText: "Set Name")),
            TextFormField(controller: rarityController, decoration: const InputDecoration(labelText: "Max Rarity")),
            TextFormField(controller: stockController, decoration: const InputDecoration(labelText: "Stock"), keyboardType: TextInputType.number),
            TextFormField(controller: priceController, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextFormField(controller: bonus2Controller, decoration: const InputDecoration(labelText: "2-Piece Bonus")),
            TextFormField(controller: bonus4Controller, decoration: const InputDecoration(labelText: "4-Piece Bonus")),
            
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submitUpdate, child: const Text("Save Changes")),
          ],
        ),
      ),
    );
  }
}