import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/coin.dart';
import '../../domain/usecases/get_coin_detail.dart';
import 'change_pill.dart';

class CoinDetailSheet extends StatelessWidget {
  final Coin initialCoin;

  const CoinDetailSheet({super.key, required this.initialCoin});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Coin?>(
      future: getIt<GetCoinDetail>()(initialCoin.uuid)
          .then((either) => either.match((failure) => null, (coin) => coin)),
      builder: (context, snapshot) {
        final coin = snapshot.data ?? initialCoin;
        final isLoadingExtra =
            snapshot.connectionState == ConnectionState.waiting;

        return _CoinDetailContent(coin: coin, isLoadingExtra: isLoadingExtra);
      },
    );
  }
}

class _CoinDetailContent extends StatelessWidget {
  final Coin coin;
  final bool isLoadingExtra;

  const _CoinDetailContent({required this.coin, required this.isLoadingExtra});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = coin.color != null
        ? Color(int.parse(coin.color!.replaceFirst('#', '0xFF')))
        : Colors.grey;

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.spaceLg,
        right: AppDimens.spaceLg,
        top: AppDimens.spaceLg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppDimens.spaceLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: TextStyle(
                        fontSize: AppDimens.fontXl,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                    Text(
                      coin.symbol,
                      style: TextStyle(
                        fontSize: AppDimens.fontMd,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              ChangePill(change: coin.change),
            ],
          ),
          const SizedBox(height: AppDimens.spaceLg),
          _DetailRow(
            label: l10n.priceLabel,
            value: Formatters.price(coin.price),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          _DetailRow(
            label: l10n.marketCapLabel,
            value: Formatters.marketCap(coin.marketCap),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          if (isLoadingExtra)
            const Center(
              child: SizedBox(
                width: AppDimens.iconMd,
                height: AppDimens.iconMd,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else ...[
            Text(
              coin.description?.isNotEmpty == true
                  ? coin.description!
                  : l10n.noDescription,
              style: const TextStyle(fontSize: AppDimens.fontMd),
            ),
            if (coin.websiteUrl != null && coin.websiteUrl!.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceMd),
              TextButton(
                onPressed: () => launchUrl(Uri.parse(coin.websiteUrl!)),
                child: Text(l10n.readMore),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(width: AppDimens.spaceXs),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
