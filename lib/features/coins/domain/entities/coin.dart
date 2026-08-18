import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  final String uuid;
  final String symbol;
  final String name;
  final String? color;
  final String iconUrl;
  final String price;
  final String marketCap;
  final String? change;
  final String? description;
  final String? websiteUrl;

  const Coin({
    required this.uuid,
    required this.symbol,
    required this.name,
    required this.color,
    required this.iconUrl,
    required this.price,
    required this.marketCap,
    this.change,
    this.description,
    this.websiteUrl,
  });

  @override
  List<Object?> get props => [
    uuid,
    symbol,
    name,
    color,
    iconUrl,
    price,
    marketCap,
    change,
    description,
    websiteUrl,
  ];
}