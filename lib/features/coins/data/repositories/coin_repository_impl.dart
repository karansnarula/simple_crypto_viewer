import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/coin_list_result.dart';
import '../../domain/repositories/coin_repository.dart';
import '../datasources/coin_remote_data_source.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource remoteDataSource;

  const CoinRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CoinListResult>> getCoins({
    String? search,
    String? cursor,
  }) async {
    try {
      final response =
      await remoteDataSource.getCoins(search: search, cursor: cursor);
      return Right(
        CoinListResult(
          coins: response.data.coins.map((m) => m.toEntity()).toList(),
          hasNextPage: response.pagination.hasNextPage,
          nextCursor: response.pagination.nextCursor,
        ),
      );
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(Failure.network(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Coin>> getCoinDetail(String uuid) async {
    try {
      final response = await remoteDataSource.getCoinDetail(uuid);
      return Right(response.data.coin.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(Failure.network(e.toString()));
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const Failure.network('No internet connection');
    }
    final status = e.response?.statusCode ?? 0;
    return Failure.server(status, 'Something went wrong');
  }
}