import 'package:equatable/equatable.dart';

import 'coin.dart';

class CoinListResult extends Equatable {
  final List<Coin> coins;
  final bool hasNextPage;
  final String? nextCursor;

  const CoinListResult({
    required this.coins,
    required this.hasNextPage,
    required this.nextCursor,
  });

  @override
  List<Object?> get props => [coins, hasNextPage, nextCursor];
}