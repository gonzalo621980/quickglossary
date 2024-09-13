import 'package:flutter/material.dart';
import 'package:quickglossary/core/enum/enum_state_trivia.dart';
import 'package:quickglossary/domain/entities/word.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TriviaState extends Equatable {
  TriviaState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends TriviaState {}

class Loading extends TriviaState {}

class Loaded extends TriviaState {
  final Word word;
  final EnumStateTrivia stateTrivia;

  Loaded({@required this.word, this.stateTrivia}) : super([word, stateTrivia]);

  @override
  List<Object> get props => [word, stateTrivia];
}

class GoToHome extends TriviaState {}

class Invalid extends TriviaState {
  final String message;
  final String code;
  final Word word;

  Invalid({@required this.message, this.code = "", this.word}) : super([message, code, word]);

  @override
  List<Object> get props => [message, code, word];
}

class Error extends TriviaState {
  final String message;

  Error({@required this.message}) : super([message]);

  @override
  List<Object> get props => [message];
}
