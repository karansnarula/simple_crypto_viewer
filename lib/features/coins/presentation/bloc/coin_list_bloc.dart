import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../domain/entities/coin.dart';
import '../../domain/usecases/get_coins.dart';
import 'coin_list_event.dart';
import 'coin_list_state.dart';

const _debounceDuration = Duration(seconds: 1);
const _topCoinsCount = 3;

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class CoinListBloc extends Bloc<CoinListEvent, CoinListState> {
  final GetCoins getCoins;

  CoinListBloc({required this.getCoins}) : super(const CoinListState()) {
    on<CoinListStarted>(_onStarted);
    on<CoinListLoadMore>(_onLoadMore, transformer: droppable());
    on<CoinListRefreshed>(_onRefreshed);
    on<CoinListRetried>(_onRetried);
    on<CoinListSearchChanged>(_onSearchChanged, transformer: _debounce(_debounceDuration));
    on<CoinListSearchCleared>(_onSearchCleared);
  }

  Future<void> _onStarted(CoinListStarted event, Emitter<CoinListState> emit) async {
    await _fetchFirstPage(emit);
  }

  Future<void> _onRetried(CoinListRetried event, Emitter<CoinListState> emit) async {
    await _fetchFirstPage(emit, search: state.searchQuery.isEmpty ? null : state.searchQuery);
  }

  Future<void> _onRefreshed(CoinListRefreshed event, Emitter<CoinListState> emit) async {
    await _fetchFirstPage(emit);
  }

  Future<void> _onSearchChanged(CoinListSearchChanged event, Emitter<CoinListState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      await _fetchFirstPage(emit);
      return;
    }
    emit(state.copyWith(
      status: CoinListStatus.loading,
      isSearching: true,
      searchQuery: query,
      coins: [],
      topCoins: [],
    ));
    await _fetchFirstPage(emit, search: query, isSearch: true);
  }

  Future<void> _onSearchCleared(CoinListSearchCleared event, Emitter<CoinListState> emit) async {
    emit(state.copyWith(isSearching: false, searchQuery: ''));
    await _fetchFirstPage(emit);
  }

  Future<void> _fetchFirstPage(
      Emitter<CoinListState> emit, {
        String? search,
        bool isSearch = false,
      }) async {
    emit(state.copyWith(
      status: CoinListStatus.loading,
      isSearching: isSearch,
      errorMessage: null,
    ));

    final result = await getCoins(search: search, cursor: null);

    result.match(
          (failure) => emit(state.copyWith(
        status: CoinListStatus.failure,
        errorMessage: failure.message,
      )),
          (data) {
        // Top-3 section only shows when NOT searching.
        final showTop = !isSearch;
        final topCoins = showTop ? data.coins.take(_topCoinsCount).toList() : <Coin>[];
        final listCoins = showTop ? data.coins.skip(_topCoinsCount).toList() : data.coins;

        emit(state.copyWith(
          status: CoinListStatus.success,
          topCoins: topCoins,
          coins: listCoins,
          hasReachedMax: !data.hasNextPage,
          nextCursor: data.nextCursor,
          isSearching: isSearch,
          searchQuery: search ?? '',
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onLoadMore(CoinListLoadMore event, Emitter<CoinListState> emit) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final search = state.searchQuery.isEmpty ? null : state.searchQuery;
    final result = await getCoins(search: search, cursor: state.nextCursor);

    result.match(
          (failure) => emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.message,
      )),
          (data) => emit(state.copyWith(
        isLoadingMore: false,
        coins: [...state.coins, ...data.coins],
        hasReachedMax: !data.hasNextPage,
        nextCursor: data.nextCursor,
        errorMessage: null,
      )),
    );
  }
}