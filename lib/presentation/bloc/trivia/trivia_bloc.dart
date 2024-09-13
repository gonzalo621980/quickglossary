import 'package:bloc/bloc.dart';
import 'package:quick_glossary/core/enum/enum_state_trivia.dart';
import 'package:quick_glossary/domain/entities/word.dart';
import 'package:meta/meta.dart';
import 'package:quick_glossary/core/error/failures.dart';
import 'package:quick_glossary/presentation/bloc/trivia/trivia_event.dart';
import 'package:quick_glossary/presentation/bloc/trivia/trivia_state.dart';
import 'package:quick_glossary/domain/usecases/word_usecase.dart';

class TriviaBloc extends Bloc<TriviaEvent, TriviaState> {
  final PickWord pickWord;
  final TestWord testWord;

  TriviaBloc({@required this.pickWord, @required this.testWord});

  @override
  TriviaState get initialState {
    return Empty();
  }

  @override
  Stream<TriviaState> mapEventToState(TriviaEvent event) async* {
    if (event is GetHome) {
      yield GoToHome();
    } else if (event is GetReload) {
      yield Loaded(word: event.word);
    } else if (event is GetPick) {
      yield Loading();

      final failureOrWords = await pickWord.call();
      yield failureOrWords.fold(
        (failure) => _mapFailureToState(failure),
        (word) => Loaded(word: word, stateTrivia: EnumStateTrivia.WAITING),
      );
    } else if (event is GetTest) {
      yield Loading();

      final failureOrWords = await testWord.call(event.word);
      yield failureOrWords.fold(
        (failure) => _mapFailureToState(failure),
        (result) => Loaded(word: event.word, stateTrivia: (result) ? EnumStateTrivia.SUCCESS : EnumStateTrivia.FAILED),
      );
    }
  }

  TriviaState _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure:
        ValidationFailure validation = (failure as ValidationFailure);
        return Invalid(message: validation.message, code: validation.code, word: validation.word);
      case CacheFailure:
        return Error(message: "Error en almacenamiento interno");
      case ServerFailure:
        return Error(message: (failure as ServerFailure).message);
      default:
        return Error(message: 'Error desconocido');
    }
  }
}
