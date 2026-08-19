import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';

class ChangePill extends StatelessWidget {
  final String? change;

  const ChangePill({super.key, required this.change});

  @override
  Widget build(BuildContext context) {
    final parsed = change != null ? double.tryParse(change!) : null;

    if (parsed == null) {
      return _buildPill(
        text: '--',
        color: Colors.grey.shade400,
      );
    }

    final isNegative = parsed < 0;
    return _buildPill(
      text: '${isNegative ? '' : '+'}${parsed.toStringAsFixed(2)}%',
      color: isNegative ? const Color(0xFFEA4B4B) : const Color(0xFF34C759),
    );
  }

  Widget _buildPill({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: AppDimens.fontSm,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}