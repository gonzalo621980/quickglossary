import 'package:dartz/dartz.dart';
import 'package:quickglossary/core/error/failures.dart';
import 'package:quickglossary/domain/entities/word.dart';

abstract class WordRepository {
  Future<Either<Failure, List<Word>>> searchWords();

  Future<Either<Failure, Word>> readWord(Word word);

  Future<Either<Failure, Word>> writeWord(Word word);

  Future<Either<Failure, bool>> deleteWord(Word word);

  Future<Either<Failure, bool>> import(String data);

  Future<Either<Failure, String>> export();
}
