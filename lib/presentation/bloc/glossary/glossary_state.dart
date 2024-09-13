import 'package:flutter/material.dart';
import 'package:quick_glossary/domain/entities/word.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GlossaryState extends Equatable {
  GlossaryState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends GlossaryState {}

class Loading extends GlossaryState {}

class Loaded extends GlossaryState {
  final Word word;
  final Color colorFont;
  final bool confirmation;

  Loaded({@required this.word, this.colorFont = Colors.grey, this.confirmation = false})
      : super([word, colorFont, confirmation]);

  @override
  List<Object> get props => [word, colorFont, confirmation];
}

class ListAll extends GlossaryState {
  final List<Word> words;

  ListAll({@required this.words}) : super([words]);

  @override
  List<Object> get props => [words];
}

class GoToHome extends GlossaryState {}

class Invalid extends GlossaryState {
  final String message;
  final String code;
  final Word word;

  Invalid({@required this.message, this.code = "", this.word}) : super([message, code, word]);

  @override
  List<Object> get props => [message, code, word];
}

class Error extends GlossaryState {
  final String message;

  Error({@required this.message}) : super([message]);

  @override
  List<Object> get props => [message];
}
