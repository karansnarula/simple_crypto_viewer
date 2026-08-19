import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        child: const SizedBox(
          width: AppDimens.iconLg,
          height: AppDimens.iconLg,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}