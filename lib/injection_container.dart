import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickglossary/data/repositories/word_repository_local.dart';
import 'package:quickglossary/domain/repositories/word_repository.dart';
import 'package:quickglossary/domain/usecases/word_usecase.dart';
import 'package:quickglossary/presentation/bloc/home/bloc.dart';
import 'package:quickglossary/presentation/bloc/glossary/bloc.dart';
import 'package:quickglossary/presentation/bloc/trivia/bloc.dart';
import 'data/datasources/local_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => HomeBloc(searchWords: sl(), import: sl(), export: sl()));
  sl.registerFactory(() => GlossaryBloc(searchWords: sl(), readWord: sl(), writeWord: sl(), deleteWord: sl()));
  sl.registerFactory(() => TriviaBloc(pickWord: sl(), testWord: sl()));

  // Use cases
  sl.registerLazySingleton(() => SearchWords(sl()));
  sl.registerLazySingleton(() => ReadWord(sl()));
  sl.registerLazySingleton(() => WriteWord(sl()));
  sl.registerLazySingleton(() => DeleteWord(sl()));
  sl.registerLazySingleton(() => PickWord(sl()));
  sl.registerLazySingleton(() => TestWord(sl()));
  sl.registerLazySingleton(() => Export(sl()));
  sl.registerLazySingleton(() => Import(sl()));

  // Repository
  sl.registerLazySingleton<WordRepository>(() => WordRepositoryLocal(localDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceLocal(sharedPreferences: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
