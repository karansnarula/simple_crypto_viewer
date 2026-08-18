import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/coin.dart';
import '../entities/coin_list_result.dart';

abstract class CoinRepository {

  Future<Either<Failure, CoinListResult>> getCoins({
    String? search,
    String? cursor,
  });

  Future<Either<Failure, Coin>> getCoinDetail(String uuid);
}