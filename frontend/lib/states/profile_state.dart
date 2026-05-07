import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';

class ProfileState {
  bool _isLoading;
  User _user;
  String _errorMessage;
  final UserService userService = UserService();

  ProfileState({
    required bool isLoading,
    required User user,
    required String errorMessage,
  }) : _isLoading = isLoading,
       _user = user,
       _errorMessage = errorMessage;

  bool get isLoading => _isLoading;
  User get user => _user;
  String get errorMessage => _errorMessage;

  ProfileState copyWith({bool? isLoading, User? user, String? errorMessage}) {
    return ProfileState(
      isLoading: isLoading ?? _isLoading,
      user: user ?? _user,
      errorMessage: errorMessage ?? _errorMessage,
    );
  }

  loadProfileData(String token) async {
    try {
      _isLoading = true;
      // Wait userService can connect to database
      // final response = await userService.fetchUserProfile(token);
      // _user = response;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
    }
  }
}
