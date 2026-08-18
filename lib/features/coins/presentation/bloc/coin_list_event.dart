import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_list_event.freezed.dart';

@freezed
class CoinListEvent with _$CoinListEvent {
  const factory CoinListEvent.started() = CoinListStarted;
  const factory CoinListEvent.loadMore() = CoinListLoadMore;
  const factory CoinListEvent.refreshed() = CoinListRefreshed;
  const factory CoinListEvent.searchChanged(String query) = CoinListSearchChanged;
  const factory CoinListEvent.searchCleared() = CoinListSearchCleared;
  const factory CoinListEvent.retried() = CoinListRetried;
}