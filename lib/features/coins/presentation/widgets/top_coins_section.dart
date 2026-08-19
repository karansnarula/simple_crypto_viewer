import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/coin.dart';
import 'change_pill.dart';

class TopCoinsSection extends StatelessWidget {
  final List<Coin> coins;
  final ValueChanged<Coin> onCoinTap;

  const TopCoinsSection({
    super.key,
    required this.coins,
    required this.onCoinTap,
  });

  @override
  Widget build(BuildContext context) {
    if (coins.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          for (int i = 0; i < coins.length; i++) ...[
            if (i > 0) const SizedBox(width: AppDimens.spaceSm),
            Expanded(
              child: _TopCoinCard(
                coin: coins[i],
                onTap: () => onCoinTap(coins[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopCoinCard extends StatelessWidget {
  final Coin coin;
  final VoidCallback onTap;

  const _TopCoinCard({required this.coin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceSm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: Formatters.toRasterIconUrl(coin.iconUrl),
                width: AppDimens.iconLg,
                height: AppDimens.iconLg,
                placeholder: (context, url) => Container(
                  width: AppDimens.iconLg,
                  height: AppDimens.iconLg,
                  color: Colors.grey.shade200,
                ),
                errorWidget: (context, url, error) => Container(
                  width: AppDimens.iconLg,
                  height: AppDimens.iconLg,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.currency_bitcoin,
                    size: AppDimens.iconMd,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              coin.symbol,
              style: const TextStyle(
                fontSize: AppDimens.fontMd,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              Formatters.price(coin.price),
              style: const TextStyle(fontSize: AppDimens.fontSm),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            ChangePill(change: coin.change),
          ],
        ),
      ),
    );
  }
}
