import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../bloc/coin_list_bloc.dart';
import '../bloc/coin_list_event.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    context.read<CoinListBloc>().add(CoinListEvent.searchChanged(value));
  }

  void _onClear() {
    _controller.clear();
    context.read<CoinListBloc>().add(const CoinListEvent.searchCleared());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _onClear,
              );
            },
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
        ),
      ),
    );
  }
}