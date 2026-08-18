import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.coinranking.com/v2';

  static String get apiKey => dotenv.env['COINRANKING_API_KEY'] ?? '';

  // Endpoints
  static const String coins = '/coins';
  static String coinDetail(String uuid) => '/coin/$uuid';

  // Pagination
  static const int pageLimit = 10;

  // Header key Coinranking expects for the API key
  static const String apiKeyHeader = 'x-access-token';
}