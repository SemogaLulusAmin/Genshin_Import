import 'package:flutter/material.dart';
import 'package:frontend/view_models/user_viewmodel.dart';
import '../../core/app_colors.dart';
import '../../view_models/auth_viewmodel.dart';
import '../theme/theme_manager.dart';
import '../../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isExpanded = false;
  final ValueNotifier<bool> isButtonLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authViewModel = AuthViewModel.instance;
    final userViewModel = UserViewModel.instance;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 24;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: AnimatedBuilder(
        animation: Listenable.merge([authViewModel, userViewModel]),
        builder: (context, _) {
          final user = authViewModel.currentUser;

          if (user == null) {
            return const Center(child: Text("User session is not loaded yet"));
          }

          final displayUsername = userViewModel.username.isNotEmpty
              ? userViewModel.username
              : user.username;

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Column(
              children: [
                /// HEADER
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            isDark
                                ? 'assets/images/Background_Dark.webp'
                                : 'assets/images/Background_Light.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.bgDark
                                : AppColors.surfaceLight,
                            width: 2,
                          ),
                          color: isDark
                              ? AppColors.bgDark
                              : AppColors.surfaceLight,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: isDark
                              ? AppColors.secondary
                              : AppColors.primary.withValues(alpha: 0.5),
                          backgroundImage: const AssetImage(
                            'assets/images/avatar.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayUsername,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "HyWenhei",
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.person, size: 16),
                          const SizedBox(width: 6),
                          Text(user.email),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// EDIT BUTTON
                      ValueListenableBuilder<bool>(
                        valueListenable: ThemeManager(),
                        builder: (context, isDark, child) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: isButtonLoading,
                            builder: (context, isLoading, child) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? Colors.white
                                        : AppColors.textPrimaryLight,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () => _showEditUsernameDialog(
                                          context,
                                          userViewModel,
                                          isButtonLoading,
                                          displayUsername,
                                        ),
                                  child: isLoading
                                      ? SizedBox(
                                          height: 16,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  isDark
                                                      ? AppColors
                                                            .textPrimaryLight
                                                      : Colors.white,
                                                ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.edit_rounded,
                                              color: isDark
                                                  ? AppColors.textPrimaryLight
                                                  : AppColors.textPrimaryDark,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Edit Profile",
                                              style: TextStyle(
                                                color: isDark
                                                    ? AppColors.textPrimaryLight
                                                    : AppColors.textPrimaryDark,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ValueListenableBuilder<bool>(
                        valueListenable: ThemeManager(),
                        builder: (context, isDark, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : AppColors.bgLight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  child: Icon(
                                    isDark ? Icons.dark_mode : Icons.light_mode,
                                    size: 20,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                                ),

                                const Expanded(
                                  child: Text(
                                    "Theme",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                Transform.scale(
                                  scale: 0.9,
                                  child: Switch(
                                    value: isDark,
                                    onChanged: (value) {
                                      ThemeManager().toggleTheme();
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: AppColors.secondary,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.grey.shade300,

                                    trackOutlineColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      /// APP INFO
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : AppColors.bgLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() => isExpanded = !isExpanded);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_rounded, size: 20),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        "App Info",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.25 : 0,
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      child: const Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            AnimatedSize(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              child: isExpanded
                                  ? Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.fromLTRB(
                                        8,
                                        0,
                                        8,
                                        12,
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.06,
                                              )
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Genshin Import",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white
                                                  : AppColors.textPrimaryLight,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "A fan-made companion app for managing artifacts, weapons, and inventories with a smooth and modern experience.",
                                            style: TextStyle(
                                              height: 1.5,
                                              fontSize: 13,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// LOGOUT
                      GestureDetector(
                        onTap: () async {
                          await AuthViewModel.instance.logout();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : AppColors.bgLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.logout_rounded, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Log out",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditUsernameDialog(
    BuildContext context,
    UserViewModel userViewModel,
    ValueNotifier<bool> loadingNotifier,
    String currentUsername,
  ) {
    final TextEditingController usernameController = TextEditingController(
      text: currentUsername,
    );

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Change Username",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          content: TextField(
            controller: usernameController,
            autofocus: true,
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            decoration: InputDecoration(
              hintText: "Input a new username",
              labelText: "Username",
              labelStyle: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryLight.withValues(alpha: 0.8)
                    : AppColors.textSecondaryLight,
              ),
              hintStyle: TextStyle(
                color: isDark ? Colors.white30 : Colors.grey.shade400,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondaryLight
                      : AppColors.textPrimaryLight.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                foregroundColor: isDark
                    ? AppColors.textPrimaryLight
                    : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
              ),
              onPressed: () async {
                final newUsername = usernameController.text.trim();

                if (newUsername.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Username cannot be null")),
                  );
                  return;
                }

                Navigator.pop(context);
                loadingNotifier.value = true;

                try {
                  final result = await UserService().editProfile(newUsername);

                  if (result['success'] == true && context.mounted) {
                    userViewModel.setUsername(newUsername);
                    await userViewModel.refreshUsername();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Username successfully updated"),
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result['message'] ?? "Fail on update profil",
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("An Error Occurred: $e")),
                    );
                  }
                } finally {
                  loadingNotifier.value = false;
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }
}
