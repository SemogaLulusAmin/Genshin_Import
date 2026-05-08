import 'package:flutter/foundation.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';

class ProfileState extends ChangeNotifier {
  final UserService userService;

  bool _isLoading = false;
  User? _user;
  String? _errorMessage;

  ProfileState({required this.userService});

  bool get isLoading => _isLoading;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfileData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await userService.getUserData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
