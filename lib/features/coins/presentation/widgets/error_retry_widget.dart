import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/app_localizations.dart';

class ErrorRetryWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorRetryWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.somethingWentWrong, style: const TextStyle(fontSize: AppDimens.fontMd, color: Colors.black87)),
            const SizedBox(height: AppDimens.spaceXs),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(l10n.tryAgain, style: const TextStyle(fontSize: AppDimens.fontMd, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}