import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/coin.dart';

part 'coin_model.g.dart';

@JsonSerializable()
class CoinModel {
  final String uuid;
  final String symbol;
  final String name;
  final String? color;
  final String iconUrl;
  final String marketCap;
  final String price;
  final String? change;
  final String? description;
  final String? websiteUrl;

  const CoinModel({
    required this.uuid,
    required this.symbol,
    required this.name,
    required this.color,
    required this.iconUrl,
    required this.marketCap,
    required this.price,
    required this.change,
    this.description,
    this.websiteUrl,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) =>
      _$CoinModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoinModelToJson(this);

  Coin toEntity() => Coin(
    uuid: uuid,
    symbol: symbol,
    name: name,
    color: color,
    iconUrl: iconUrl,
    marketCap: marketCap,
    price: price,
    change: change,
    description: description,
    websiteUrl: websiteUrl,
  );
}