import 'package:meta/meta.dart';

class ValidationException implements Exception {
  final dynamic message;
  ValidationException({@required this.message});
}

class ComunicationException implements Exception {
  final dynamic message;
  ComunicationException({@required this.message});
}

class CacheException implements Exception {}

class ServerException implements Exception {
  final dynamic message;
  ServerException({@required this.message});
}