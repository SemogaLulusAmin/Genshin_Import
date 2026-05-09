import 'package:flutter/material.dart';
import '../../models/artifact_model.dart';
import '../../services/artifact_service.dart';
import '../../services/auth_service.dart';
import 'admin_artifact_form_screen.dart';

class AdminArtifactListScreen extends StatefulWidget {
  const AdminArtifactListScreen({super.key});

  @override
  State<AdminArtifactListScreen> createState() => _AdminArtifactListScreenState();
}

class _AdminArtifactListScreenState extends State<AdminArtifactListScreen> {
  final ArtifactService _artifactService = ArtifactService();
  final AuthService _authService = AuthService();
  List<Artifact> _artifacts = [];
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
    _loadArtifacts();
  }

  Future<void> _loadArtifacts() async {
    setState(() => _isLoading = true);
    try {
      final artifacts = await _artifactService.getArtifacts();
      setState(() {
        _artifacts = artifacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading artifacts: $e')),
        );
      }
    }
  }

  Future<void> _deleteArtifact(String artifactId) async {
    try {
      await _artifactService.deleteArtifact(artifactId);
      _loadArtifacts(); // Reload the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artifact deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting artifact: $e')),
        );
      }
    }
  }

  void _showDeleteDialog(String artifactId, String artifactName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Artifact'),
        content: Text('Are you sure you want to delete "$artifactName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteArtifact(artifactId);
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
        title: const Text('Manage Artifacts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminArtifactFormScreen(),
                ),
              );
              if (result == true) {
                _loadArtifacts();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _artifacts.isEmpty
              ? const Center(child: Text('No artifacts found'))
              : ListView.builder(
                  itemCount: _artifacts.length,
                  itemBuilder: (context, index) {
                    final artifact = _artifacts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: artifact.imageUrl.isNotEmpty
                            ? Image.network(
                                'http://localhost:3000${artifact.imageUrl}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                              )
                            : const Icon(Icons.inventory, size: 50),
                        title: Text(artifact.name),
                        subtitle: Text('${artifact.setName} • ${artifact.maxRarity} • Stock: ${artifact.stock}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminArtifactFormScreen(artifact: artifact),
                                  ),
                                );
                                if (result == true) {
                                  _loadArtifacts();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _showDeleteDialog(artifact.artifactID, artifact.name),
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