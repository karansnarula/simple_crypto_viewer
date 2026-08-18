import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/coins/data/datasources/coin_remote_data_source.dart';
import '../../features/coins/data/repositories/coin_repository_impl.dart';
import '../../features/coins/domain/repositories/coin_repository.dart';
import '../../features/coins/domain/usecases/get_coin_detail.dart';
import '../../features/coins/domain/usecases/get_coins.dart';
import '../../features/coins/presentation/bloc/coin_list_bloc.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<Dio>(() => DioClient.create());

  // Data source
  getIt.registerLazySingleton<CoinRemoteDataSource>(
        () => CoinRemoteDataSource(getIt<Dio>()),
  );

// Repository
  getIt.registerLazySingleton<CoinRepository>(
        () => CoinRepositoryImpl(getIt<CoinRemoteDataSource>()),
  );

// Usecases
  getIt.registerLazySingleton(() => GetCoins(getIt<CoinRepository>()));
  getIt.registerLazySingleton(() => GetCoinDetail(getIt<CoinRepository>()));

// Bloc
  getIt.registerFactory(() => CoinListBloc(
    getCoins: getIt<GetCoins>(),
  ));
}