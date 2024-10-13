import 'package:bloc/bloc.dart';
import 'package:quickglossary/domain/entities/word.dart';
import 'package:meta/meta.dart';
import 'package:quickglossary/core/error/failures.dart';
import 'package:quickglossary/presentation/bloc/glossary/glossary_event.dart';
import 'package:quickglossary/presentation/bloc/glossary/glossary_state.dart';
import 'package:quickglossary/domain/usecases/word_usecase.dart';

class GlossaryBloc extends Bloc<GlossaryEvent, GlossaryState> {
  final SearchWords searchWords;
  final ReadWord readWord;
  final WriteWord writeWord;
  final DeleteWord deleteWord;

  GlossaryBloc(
      {@required this.searchWords, @required this.readWord, @required this.writeWord, @required this.deleteWord});

  @override
  GlossaryState get initialState {
    return Empty();
  }

  @override
  Stream<GlossaryState> mapEventToState(GlossaryEvent event) async* {
    if (event is GetHome) {
      yield GoToHome();
    } else if (event is GetReload) {
      yield Loaded(word: event.word);
    } else if (event is GetRead) {
      yield Loading();

      final failureOrWord = await readWord.call(event.word);
      yield failureOrWord.fold(
        (failure) => _mapFailureToState(failure),
        (word) => Loaded(word: word),
      );
    } else if (event is GetReadAll) {
      yield Loading();

      final failureOrWords = await searchWords.call();
      yield failureOrWords.fold(
        (failure) => _mapFailureToState(failure),
        (words) => ListAll(words: words),
      );
    } else if (event is GetWrite) {
      yield Loading();

      final failureOrWords = await writeWord.call(event.word);
      yield failureOrWords.fold(
        (failure) => _mapFailureToState(failure),
        (word) => Loaded(word: new Word()),
      );
    } else if (event is GetDelete) {
      yield Loading();

      if (event.confirmation) {
        final failureOrWords = await deleteWord.call(event.word);
        yield failureOrWords.fold(
          (failure) => _mapFailureToState(failure),
          (word) => Loaded(word: new Word(), confirmation: false),
        );
      } else {
        yield Loaded(word: event.word, confirmation: true);
      }
    }
  }

  GlossaryState _mapFailureToState(Failure failure) {
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
