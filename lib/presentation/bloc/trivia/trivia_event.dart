import 'package:quickglossary/domain/entities/word.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TriviaEvent extends Equatable {
  TriviaEvent([List props = const <dynamic>[]]) : super(props);
}

class GetHome extends TriviaEvent {
  GetHome() : super([]);

  @override
  List<Object> get props => [];
}

class GetPick extends TriviaEvent {
  GetPick() : super();

  @override
  List<Object> get props => [];
}

class GetTest extends TriviaEvent {
  final Word word;

  GetTest({this.word}) : super([word]);

  @override
  List<Object> get props => [word];
}

class GetRead extends TriviaEvent {
  final Word word;

  GetRead({this.word}) : super([word]);

  @override
  List<Object> get props => [word];
}

class GetReload extends TriviaEvent {
  final Word word;

  GetReload({this.word}) : super([word]);

  @override
  List<Object> get props => [word];
}
