import 'package:frontend/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';

class AuthViewModel extends ChangeNotifier {
  final UserModel? user;
  final UserService _userService = UserService();

  AuthViewModel({this.user});
}
