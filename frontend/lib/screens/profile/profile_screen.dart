import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../view_models/auth_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authViewModel = AuthViewModel.instance;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: AnimatedBuilder(
        animation: authViewModel,
        builder: (context, _) {
          final user = authViewModel.currentUser;

          if (user == null) {
            return const Center(child: Text("User session is not loaded yet"));
          }

          return SingleChildScrollView(
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
                                ? 'assets/images/Background_Dark.jpg'
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
                        padding: const EdgeInsets.all(4), // ketebalan outline
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
                        user.username,
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? Colors.white
                                : AppColors.textPrimaryLight,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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

                      /// THEME (read-only for now)
                      Container(
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
                          children: [
                            const Icon(Icons.palette, size: 20),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "Theme",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              size: 20,
                            ),
                          ],
                        ),
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
                              SizedBox(width: 10),
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
}
