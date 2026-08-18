import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/coin_detail_response_model.dart';
import '../models/coin_list_response_model.dart';

part 'coin_remote_data_source.g.dart';

@RestApi()
abstract class CoinRemoteDataSource {
  factory CoinRemoteDataSource(Dio dio) = _CoinRemoteDataSource;

  @GET('/coins')
  Future<CoinListResponseModel> getCoins({
    @Query('limit') int limit = ApiConstants.pageLimit,
    @Query('search') String? search,
    @Query('cursor') String? cursor,
  });

  @GET('/coin/{uuid}')
  Future<CoinDetailResponseModel> getCoinDetail(@Path('uuid') String uuid);
}