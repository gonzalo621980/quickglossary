import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const <dynamic>[]]) : super(props);
}

class GetGlossary extends HomeEvent {
  GetGlossary() : super([]);

  @override
  List<Object> get props => [];
}

class GetTrivia extends HomeEvent {
  GetTrivia() : super([]);

  @override
  List<Object> get props => [];
}

class GetReload extends HomeEvent {
  GetReload() : super([]);

  @override
  List<Object> get props => [];
}

class GetImport extends HomeEvent {
  final String data;

  GetImport(this.data) : super([data]);

  @override
  List<Object> get props => [data];
}

class GetExport extends HomeEvent {
  GetExport() : super([]);

  @override
  List<Object> get props => [];
}
