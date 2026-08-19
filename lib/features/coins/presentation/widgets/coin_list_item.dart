import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/coin.dart';
import 'change_pill.dart';

class CoinListItem extends StatelessWidget {
  final Coin coin;
  final VoidCallback onTap;

  const CoinListItem({super.key, required this.coin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceSm,
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: Formatters.toRasterIconUrl(coin.iconUrl),
                width: AppDimens.coinIconSize,
                height: AppDimens.coinIconSize,
                placeholder: (context, url) => Container(
                  width: AppDimens.coinIconSize,
                  height: AppDimens.coinIconSize,
                  color: Colors.grey.shade200,
                ),
                errorWidget: (context, url, error) => Container(
                  width: AppDimens.coinIconSize,
                  height: AppDimens.coinIconSize,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.currency_bitcoin, size: AppDimens.iconMd),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.symbol,
                    style: const TextStyle(
                      fontSize: AppDimens.fontLg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    Formatters.marketCap(coin.marketCap),
                    style: TextStyle(
                      fontSize: AppDimens.fontSm,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatters.price(coin.price),
                  style: const TextStyle(
                    fontSize: AppDimens.fontMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                ChangePill(change: coin.change),
              ],
            ),
          ],
        ),
      ),
    );
  }
}