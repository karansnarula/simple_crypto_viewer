import 'package:json_annotation/json_annotation.dart';

import 'coin_model.dart';

part 'coin_detail_response_model.g.dart';

@JsonSerializable(createToJson: false)
class CoinDetailResponseModel {
  final CoinDetailData data;

  const CoinDetailResponseModel({required this.data});

  factory CoinDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class CoinDetailData {
  final CoinModel coin;

  const CoinDetailData({required this.coin});

  factory CoinDetailData.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailDataFromJson(json);
}