import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/coin.dart';
import '../../domain/usecases/get_coins.dart';
import '../bloc/coin_list_bloc.dart';
import '../bloc/coin_list_event.dart';
import '../bloc/coin_list_state.dart';
import '../widgets/coin_detail_sheet.dart';
import '../widgets/coin_list_item.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/invite_friends_tile.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/top_coins_section.dart';

class CoinListPage extends StatelessWidget {
  const CoinListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CoinListBloc(getCoins: getIt<GetCoins>())
            ..add(const CoinListEvent.started()),
      child: const _CoinListView(),
    );
  }
}

class _CoinListView extends StatefulWidget {
  const _CoinListView();

  @override
  State<_CoinListView> createState() => _CoinListViewState();
}

class _CoinListViewState extends State<_CoinListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CoinListBloc>().add(const CoinListEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetail(Coin coin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLg),
        ),
      ),
      builder: (_) => CoinDetailSheet(initialCoin: coin),
    );
  }

  List<Widget> _buildRows(List<Coin> coins) {
    final rows = <Widget>[];
    int nextInvitePosition = 5;
    int coinIndex = 0;

    while (coinIndex < coins.length) {
      if (rows.length + 1 == nextInvitePosition) {
        rows.add(const InviteFriendsTile());
        nextInvitePosition *= 2;
      } else {
        final Coin coin = coins[coinIndex];
        rows.add(CoinListItem(coin: coin, onTap: () => _openDetail(coin)));
        coinIndex++;
      }
    }
    return rows;
  }

  Widget _buildBody(BuildContext context, CoinListState state) {
    final isInitialLoad =
        (state.status == CoinListStatus.initial ||
            state.status == CoinListStatus.loading) &&
        state.coins.isEmpty;

    if (isInitialLoad) {
      return const LoadingIndicator();
    }

    if (state.status == CoinListStatus.failure) {
      return ErrorRetryWidget(
        onRetry: () =>
            context.read<CoinListBloc>().add(const CoinListEvent.retried()),
      );
    }

    final rows = _buildRows(state.coins);
    final showEmptyState = state.isSearching && state.coins.isEmpty;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent == 0 &&
          !state.hasReachedMax &&
          !state.isLoadingMore) {
        context.read<CoinListBloc>().add(const CoinListEvent.loadMore());
      }
    });

    return Column(
      children: [
        if (!state.isSearching)
          TopCoinsSection(coins: state.topCoins, onCoinTap: _openDetail),
        Expanded(
          child: RefreshIndicator(
            notificationPredicate: state.isSearching
                ? (_) => false
                : (_) => true,
            onRefresh: () async {
              context.read<CoinListBloc>().add(const CoinListEvent.refreshed());
            },
            child: showEmptyState
                ? const _EmptyState()
                : ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
              ),
              itemCount:
              rows.length + (state.isLoadingMore || state.hasPaginationError ? 1 : 0),
              separatorBuilder: (context, index) {
                if (index >= rows.length - 1) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(
                    left: AppDimens.coinIconSize + AppDimens.spaceMd,
                  ),
                  child: Divider(height: 1, color: Colors.grey.shade400),
                );
              },
              itemBuilder: (context, index) {
                if (index < rows.length) return rows[index];

                if (state.hasPaginationError) {
                  return ErrorRetryWidget(
                    onRetry: () =>
                        context.read<CoinListBloc>().add(const CoinListEvent.loadMore()),
                  );
                }

                return const LoadingIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            child: Column(
              children: [
                const SearchBarWidget(),
                Expanded(
                  child: BlocBuilder<CoinListBloc, CoinListState>(
                    builder: _buildBody,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXl * 2),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.noCoinsFound,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }
}
