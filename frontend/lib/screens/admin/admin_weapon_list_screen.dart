import 'package:flutter/material.dart';
import '../../models/weapon_model.dart';
import '../../services/weapon_service.dart';
import '../../services/auth_service.dart';
import 'admin_weapon_form_screen.dart';

class AdminWeaponListScreen extends StatefulWidget {
  const AdminWeaponListScreen({super.key});

  @override
  State<AdminWeaponListScreen> createState() => _AdminWeaponListScreenState();
}

class _AdminWeaponListScreenState extends State<AdminWeaponListScreen> {
  final WeaponService _weaponService = WeaponService();
  final AuthService _authService = AuthService();
  List<Weapon> _weapons = [];
  bool _isLoading = true;
  bool? _isAdmin;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
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
    _loadWeapons();
  }

  Future<void> _loadWeapons() async {
    setState(() => _isLoading = true);
    try {
      final weapons = await _weaponService.getWeapons();
      setState(() {
        _weapons = weapons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading weapons: $e')),
        );
      }
    }
  }

  Future<void> _deleteWeapon(String weaponId) async {
    try {
      await _weaponService.deleteWeapon(weaponId);
      _loadWeapons(); // Reload the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Weapon deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting weapon: $e')),
        );
      }
    }
  }

  void _showDeleteDialog(String weaponId, String weaponName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Weapon'),
        content: Text('Are you sure you want to delete "$weaponName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteWeapon(weaponId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
        title: const Text('Manage Weapons'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminWeaponFormScreen(),
                ),
              );
              if (result == true) {
                _loadWeapons();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _weapons.isEmpty
              ? const Center(child: Text('No weapons found'))
              : ListView.builder(
                  itemCount: _weapons.length,
                  itemBuilder: (context, index) {
                    final weapon = _weapons[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: weapon.imageUrl.isNotEmpty
                            ? Image.network(
                                'http://localhost:3000${weapon.imageUrl}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                              )
                            : const Icon(Icons.inventory, size: 50),
                        title: Text(weapon.name),
                        subtitle: Text('${weapon.type} • ${weapon.rarity} • Stock: ${weapon.stock}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminWeaponFormScreen(weapon: weapon),
                                  ),
                                );
                                if (result == true) {
                                  _loadWeapons();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _showDeleteDialog(weapon.weaponID, weapon.name),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}