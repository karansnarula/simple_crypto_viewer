import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/coin.dart';

part 'coin_list_state.freezed.dart';

enum CoinListStatus { initial, loading, success, failure }

@freezed
abstract class CoinListState with _$CoinListState {
  const factory CoinListState({
    @Default(CoinListStatus.initial) CoinListStatus status,
    @Default([]) List<Coin> coins,
    @Default([]) List<Coin> topCoins,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isSearching,
    @Default('') String searchQuery,
    String? nextCursor,
    String? errorMessage,
  }) = _CoinListState;

  const CoinListState._();

  bool get hasPaginationError =>
      errorMessage != null && !isLoadingMore && coins.isNotEmpty;
}