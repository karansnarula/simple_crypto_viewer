import 'package:json_annotation/json_annotation.dart';

import 'coin_model.dart';

part 'coin_list_response_model.g.dart';

@JsonSerializable(createToJson: false)
class CoinListResponseModel {
  final CoinListData data;
  final PaginationModel pagination;

  const CoinListResponseModel({required this.data, required this.pagination});

  factory CoinListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CoinListResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class CoinListData {
  final List<CoinModel> coins;

  const CoinListData({required this.coins});

  factory CoinListData.fromJson(Map<String, dynamic> json) =>
      _$CoinListDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class PaginationModel {
  final bool hasNextPage;
  final String? nextCursor;

  const PaginationModel({required this.hasNextPage, this.nextCursor});

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}