import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState extends Equatable {
  HomeState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends HomeState {}

class Loading extends HomeState {}

class Loaded extends HomeState {
  final int countWords;

  Loaded({@required this.countWords}) : super([countWords]);

  @override
  List<Object> get props => [countWords];
}

class Imported extends HomeState {}

class Exported extends HomeState {
  final String data;

  Exported({@required this.data}) : super([data]);

  @override
  List<Object> get props => [data];
}

class GoToTrivia extends HomeState {}

class GoToGlossary extends HomeState {}

class Error extends HomeState {
  final String message;

  Error({@required this.message}) : super([message]);

  @override
  List<Object> get props => [message];
}
