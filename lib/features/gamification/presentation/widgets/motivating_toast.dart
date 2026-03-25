import 'package:flutter/material.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';

class MotivatingToast {
  static void show(
    BuildContext context, {
    required String message,
    String? icon,
    Color? color,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          if (icon != null) ...[
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
          ],
          Expanded(
              child: Text(message,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white))),
        ]),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        duration: duration,
      ),
    );
  }
}
