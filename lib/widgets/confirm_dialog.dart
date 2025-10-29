import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Custom Confirmation Dialog theo style iOS/Material
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDanger; // true = nút đỏ (xóa)

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Xác nhận',
    this.cancelText = 'Hủy',
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14), // iOS style radius
      ),
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250), // Thu hẹp lại
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(
                top: 19,
                left: 16,
                right: 16,
                bottom: 2,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w600, // iOS semibold
                  letterSpacing: -0.41,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Message
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: 19,
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  letterSpacing: -0.08,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Divider ngang - dính sát biên
            const Divider(height: 0.5, thickness: 0.5, indent: 0, endIndent: 0),

            // Buttons - 2 nút ngang
            SizedBox(
              height: 44, // iOS button height
              child: Row(
                children: [
                  // Cancel button (left)
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: AppColors.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(14),
                          ),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 17,
                          fontWeight: FontWeight.w500, // Medium
                          letterSpacing: -0.41,
                        ),
                      ),
                    ),
                  ),

                  // Divider dọc giữa 2 nút
                  Container(width: 0.5, height: 44, color: AppColors.divider),

                  // Confirm button (right)
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: isDanger
                            ? AppColors.error
                            : AppColors.primary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(14),
                          ),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 17,
                          fontWeight: FontWeight.w600, // Semibold for action
                          letterSpacing: -0.41,
                          color: isDanger ? AppColors.error : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show Delete Confirmation Dialog
  static Future<bool> showDelete({
    required BuildContext context,
    required String itemName,
    String? customMessage,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        title: 'Xác nhận xóa',
        message: customMessage ?? 'Hành động này không thể hoàn tác!',
        confirmText: 'Xóa',
        cancelText: 'Hủy',
        isDanger: true,
      ),
    );
    return result ?? false;
  }

  /// Show General Confirmation Dialog
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDanger: isDanger,
      ),
    );
    return result ?? false;
  }
}
