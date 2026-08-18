import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/coin_list_result.dart';
import '../repositories/coin_repository.dart';

class GetCoins {
  final CoinRepository repository;

  const GetCoins(this.repository);

  Future<Either<Failure, CoinListResult>> call({
    String? search,
    String? cursor,
  }) {
    return repository.getCoins(search: search, cursor: cursor);
  }
}