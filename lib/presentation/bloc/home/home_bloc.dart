import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quick_glossary/core/error/failures.dart';
import 'package:quick_glossary/presentation/bloc/home/home_event.dart';
import 'package:quick_glossary/presentation/bloc/home/home_state.dart';
import 'package:quick_glossary/domain/usecases/word_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SearchWords searchWords;
  final Import import;
  final Export export;

  HomeBloc({@required this.searchWords, @required this.import, @required this.export});

  @override
  HomeState get initialState {
    return Empty();
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetTrivia) {
      yield GoToTrivia();
    } else if (event is GetGlossary) {
      yield GoToGlossary();
    } else if (event is GetImport) {
      yield Loading();

      final failureOrResult = await import.call(event.data);
      yield failureOrResult.fold(
        (failure) => _mapFailureToState(failure),
        (result) => Imported(),
      );
    } else if (event is GetExport) {
      yield Loading();

      final failureOrData = await export.call();
      yield failureOrData.fold(
        (failure) => _mapFailureToState(failure),
        (data) => Exported(data: data),
      );
    } else if (event is GetReload) {
      yield Loading();

      final failureOrWords = await searchWords.call();
      yield failureOrWords.fold(
        (failure) => _mapFailureToState(failure),
        (words) => Loaded(countWords: words.length),
      );
    }
  }

  HomeState _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return Error(message: "Error en almacenamiento interno");
      case ServerFailure:
        return Error(message: (failure as ServerFailure).message);
      default:
        return Error(message: 'Error desconocido');
    }
  }
}
