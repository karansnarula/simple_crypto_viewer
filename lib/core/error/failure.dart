import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.server(int statusCode, String message) = ServerFailure;
}