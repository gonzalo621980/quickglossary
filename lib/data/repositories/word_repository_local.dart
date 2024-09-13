import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:quick_glossary/core/error/exception.dart';
import 'package:quick_glossary/core/error/failures.dart';
import 'package:quick_glossary/data/datasources/local_data_source.dart';
import 'package:quick_glossary/domain/repositories/word_repository.dart';
import 'package:quick_glossary/domain/entities/cached_data.dart';
import 'package:quick_glossary/domain/entities/word.dart';
import 'package:uuid/uuid.dart';

class WordRepositoryLocal extends WordRepository {
  final LocalDataSource localDataSource;

  WordRepositoryLocal({
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Word>>> searchWords() async {
    try {
      CachedData data = await localDataSource.getData();
      data.listWords.sort((a, b) => a.englishText.compareTo(b.englishText));
      return Right(data.listWords);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Word>> readWord(Word word) async {
    try {
      CachedData data = await localDataSource.getData();
      Word row = data.listWords.firstWhere(
          (x) => (word.category == "" || word.category == x.category) && x.englishText == word.englishText,
          orElse: () => null);
      if (row != null) {
        return Right(row);
      } else {
        return Left(ValidationFailure(message: "unknown word", code: "UNKNOWN_WORD", word: word));
      }
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Word>> writeWord(Word word) async {
    try {
      CachedData data = await localDataSource.getData();
      data.listWords.any((x) => x.englishText == word.englishText);
      Word row = data.listWords.firstWhere((x) => x.englishText == word.englishText, orElse: () => null);
      if (row != null) {
        int indexRow = data.listWords.indexOf(row);
        data.listWords[indexRow] = word;
      } else {
        var uuid = Uuid();
        word.id = uuid.v4();
        data.listWords.add(word);
      }

      bool success = await localDataSource.setData(data);
      if (success) {
        return Right(word);
      } else {
        return Left(CacheFailure());
      }
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ComunicationException {
      return Left(ComunicationFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteWord(Word word) async {
    try {
      CachedData data = await localDataSource.getData();
      Word row = data.listWords.firstWhere((x) => x.englishText == word.englishText, orElse: () => null);
      if (row != null) {
        data.listWords.remove(row);
        bool success = await localDataSource.setData(data);
        if (success) {
          return Right(true);
        } else {
          return Left(CacheFailure());
        }
      } else {
        return Left(ValidationFailure(message: "unknown word"));
      }
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ComunicationException {
      return Left(ComunicationFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> import(String data) async {
    try {
      await localDataSource.importData(data);
      return Right(true);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> export() async {
    try {
      String data = await localDataSource.exportData();
      return Right(data);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
