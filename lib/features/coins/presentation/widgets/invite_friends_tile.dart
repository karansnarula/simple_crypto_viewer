import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/app_localizations.dart';

class InviteFriendsTile extends StatelessWidget {
  const InviteFriendsTile({super.key});

  static const String _inviteUrl = 'https://www.7solutions.co.th/jobs';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => SharePlus.instance.share(ShareParams(text: _inviteUrl)),
      child: Container(
        color: Colors.deepPurple.withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceSm,
        ),
        child: Row(
          children: [
            Container(
              width: AppDimens.coinIconSize,
              height: AppDimens.coinIconSize,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_add_alt_1, color: Colors.deepPurple),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.inviteFriends,
                    style: const TextStyle(
                      fontSize: AppDimens.fontLg,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    l10n.inviteFriendsSubtitle,
                    style: TextStyle(
                      fontSize: AppDimens.fontSm,
                      color: Colors.deepPurple.shade300,
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
}