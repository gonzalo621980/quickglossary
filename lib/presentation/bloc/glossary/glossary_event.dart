import 'package:quickglossary/domain/entities/word.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GlossaryEvent extends Equatable {
  GlossaryEvent([List props = const <dynamic>[]]) : super(props);
}

class GetHome extends GlossaryEvent {
  GetHome() : super([]);

  @override
  List<Object> get props => [];
}

class GetReadAll extends GlossaryEvent {
  GetReadAll() : super([]);

  @override
  List<Object> get props => [];
}

class GetRead extends GlossaryEvent {
  final Word word;

  GetRead({this.word}) : super([word]);

  @override
  List<Object> get props => [word];
}

class GetWrite extends GlossaryEvent {
  final Word word;

  GetWrite({this.word}) : super([word]);

  @override
  List<Object> get props => [word];
}

class GetDelete extends GlossaryEvent {
  final Word word;
  final bool confirmation;

  GetDelete({this.word, this.confirmation}) : super([word, confirmation]);

  @override
  List<Object> get props => [word, confirmation];
}

class GetReload extends GlossaryEvent {
  final Word word;

  GetReload({this.word}) : super([word]);

  @override
  List<Object> get props => [word];
}
