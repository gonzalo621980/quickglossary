import 'package:equatable/equatable.dart';
import 'package:quickglossary/domain/entities/word.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]) : super(properties);
}

class ValidationFailure extends Failure {
  final String message;
  final String code;
  final Word word;
  ValidationFailure({this.message = "", this.code = "", this.word}) : super([message, code, word]);
}

class ComunicationFailure extends Failure {}

class CacheFailure extends Failure {}

class ServerFailure extends Failure {
  final String message;
  ServerFailure({this.message = ""}) : super([message]);
}
