import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_form_field.dart';
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
    final bottomPadding =
        MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).viewInsets.bottom +
        16;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Weapon"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
            children: [
              if (_selectedImage != null)
                Image.network(_selectedImage!.path, height: 120)
              else
                Image.network(widget.weapon.imageUrl, height: 120),

              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Change Image"),
              ),

              CustomFormField(
                label: 'WEAPON NAME',
                hintText: 'Enter weapon name',
                controller: nameController,
              ),

              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      label: 'TYPE',
                      hintText: 'Enter weapon type',
                      controller: typeController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomFormField(
                      label: 'RARITY',
                      hintText: 'Enter weapon rarity',
                      controller: rarityController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      label: 'BASE ATTACK',
                      hintText: 'Enter weapon base attack',
                      controller: attackController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomFormField(
                      label: 'SUB STAT',
                      hintText: 'Enter weapon sub stat',
                      controller: subStatController,
                    ),
                  ),
                ],
              ),

              CustomFormField(
                label: 'PASSIVE NAME',
                hintText: "Enter the weapon's passive name",
                controller: passiveNameController,
              ),

              CustomFormField(
                label: 'PASSIVE DESCRIPTION',
                hintText: "Enter the weapon's passive effect",
                controller: passiveDescController,
              ),

              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      label: 'PRICE',
                      hintText: 'Enter weapon price',
                      controller: priceController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomFormField(
                      label: 'STOCK',
                      hintText: 'Enter weapon stock',
                      controller: stockController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              CustomButton(text: 'Save Changes', onPressed: _submitUpdate),
            ],
          ),
        ),
      ),
    );
  }
}
