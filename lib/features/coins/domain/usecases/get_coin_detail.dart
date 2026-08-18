import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/coin.dart';
import '../repositories/coin_repository.dart';

class GetCoinDetail {
  final CoinRepository repository;

  const GetCoinDetail(this.repository);

  Future<Either<Failure, Coin>> call(String uuid) {
    return repository.getCoinDetail(uuid);
  }
}