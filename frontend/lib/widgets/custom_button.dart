import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Mengecek apakah tema saat ini gelap atau terang
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // LOGIKA PERUBAHAN WARNA DISINI
          backgroundColor: isDark
              ? AppColors
                    .primary // Light button untuk Dark Theme
              : AppColors.surfaceDark, // Dark button untuk Light Theme

          foregroundColor:
              AppColors.textPrimaryDark, // Teks putih jika tombol gelap

          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              4,
            ), // Mengikuti style login sebelumnya
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  // Progress indicator juga ikut berubah warna
                  color: isDark ? Colors.black : Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
