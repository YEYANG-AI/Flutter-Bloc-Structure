import 'package:equatable/equatable.dart';

class HomeModel extends Equatable {
  final String symbol;
  final String name;
  final String price;
  final String change;
  final bool isPositive;
  final String logoPath;

  const HomeModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.isPositive,
    required this.logoPath,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      price: json['price'] as String,
      change: json['change'] as String,
      isPositive: json['isPositive'] as bool,
      logoPath: json['logoPath'] as String,
    );
  }

  @override
  List<Object?> get props => [
    symbol,
    name,
    price,
    change,
    isPositive,
    logoPath,
  ];
}
