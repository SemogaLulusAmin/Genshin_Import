import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/weapon_model.dart';
import '../../services/weapon_service.dart';

class WeaponEditScreen extends StatefulWidget {
  final Weapon weapon;
  const WeaponEditScreen({super.key, required this.weapon});

  @override
  State<WeaponEditScreen> createState() => _WeaponEditScreenState();
}

class _WeaponEditScreenState extends State<WeaponEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController rarityController;
  late TextEditingController attackController;
  late TextEditingController subStatController;
  late TextEditingController passiveNameController;
  late TextEditingController passiveDescController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.weapon.name);
    typeController = TextEditingController(text: widget.weapon.type);
    rarityController = TextEditingController(
      text: widget.weapon.rarity.toString(),
    );
    attackController = TextEditingController(
      text: widget.weapon.baseAttack.toString(),
    );
    subStatController = TextEditingController(text: widget.weapon.subStat);
    passiveNameController = TextEditingController(
      text: widget.weapon.passiveName,
    );
    passiveDescController = TextEditingController(
      text: widget.weapon.passiveDesc,
    );
    priceController = TextEditingController(
      text: widget.weapon.price.toString(),
    );
    stockController = TextEditingController(
      text: widget.weapon.stock.toString(),
    );
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
      'type': typeController.text,
      'rarity': rarityController.text,
      'baseAttack': attackController.text,
      'subStat': subStatController.text,
      'passiveName': passiveNameController.text,
      'passiveDesc': passiveDescController.text,
      'price': priceController.text,
      'stock': stockController.text,
    };

    try {
      final success = await WeaponService().updateWeapon(
        widget.weapon.weaponID,
        fields,
        _selectedImage,
      );

      if (success && mounted) {
        Navigator.of(context).pop(true);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Weapon Updated!")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Weapon"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_selectedImage != null)
              Image.network(_selectedImage!.path, height: 120)
            else
              Image.network(widget.weapon.imageUrl, height: 120),

            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Change Image (Optional)"),
            ),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Weapon Name"),
            ),
            TextFormField(
              controller: typeController,
              decoration: const InputDecoration(labelText: "Type"),
            ),
            TextFormField(
              controller: rarityController,
              decoration: const InputDecoration(labelText: "Rarity"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: attackController,
              decoration: const InputDecoration(labelText: "Base Attack"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: subStatController,
              decoration: const InputDecoration(labelText: "Sub Stat"),
            ),
            TextFormField(
              controller: passiveNameController,
              decoration: const InputDecoration(labelText: "Passive Name"),
            ),
            TextFormField(
              controller: passiveDescController,
              decoration: const InputDecoration(
                labelText: "Passive Description",
              ),
              maxLines: 2,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: stockController,
              decoration: const InputDecoration(labelText: "Stock"),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _submitUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
