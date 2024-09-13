import 'package:dartz/dartz.dart';
import 'dart:math';
import 'package:quickglossary/core/error/failures.dart';
import 'package:quickglossary/core/helper.dart';
import 'package:quickglossary/domain/entities/word.dart';
import 'package:quickglossary/domain/repositories/word_repository.dart';

class SearchWords {
  final WordRepository wordRepository;

  SearchWords(this.wordRepository);

  Future<Either<Failure, List<Word>>> call() async {
    final failureOrWords = await this.wordRepository.searchWords();
    return failureOrWords.fold((failure) => Left(failure), (words) => Right(words));
  }
}

class PickWord {
  final WordRepository wordRepository;

  PickWord(this.wordRepository);

  Future<Either<Failure, Word>> call() async {
    final failureOrWords = await this.wordRepository.searchWords();
    if (failureOrWords.isLeft()) {
      return Left(Helper.getLeft(failureOrWords));
    }

    List<Word> words = Helper.getRight(failureOrWords);
    List<int> scores = [];
    int scoreLength = 0;
    for (int w = 0; w < words.length; w++) {
      int score = Helper.getScore(words[w]);
      for (int i = 0; i < score; i++) scores.add(w);
      scoreLength += score;
    }

    final random = Random();
    int indexRandom = random.nextInt(scoreLength);
    int indexWord = scores[indexRandom];

    Word word = words[indexWord];
    return Right(word);
  }
}

class TestWord {
  final WordRepository wordRepository;

  TestWord(this.wordRepository);

  Future<Either<Failure, bool>> call(Word word) async {
    if (word.englishText.length <= 0) {
      return Left(ValidationFailure(message: "english text is required", word: word));
    }
    if (word.spanishText.length <= 0) {
      return Left(ValidationFailure(message: "spanish text is required", word: word));
    }

    final failureOrStoredWord = await this.wordRepository.readWord(word);
    if (failureOrStoredWord.isLeft()) {
      return Left(Helper.getLeft(failureOrStoredWord));
    }

    Word storedWord = Helper.getRight(failureOrStoredWord);
    bool success = (storedWord.spanishText == word.spanishText);
    if (success) {
      storedWord.continuousSuccessCount++;
      storedWord.successCount++;
    } else {
      storedWord.continuousSuccessCount = 0;
      storedWord.failureCount++;
    }
    storedWord.modifyDate = Helper.getTimestamp();

    final failureOrWord = await this.wordRepository.writeWord(storedWord);
    if (failureOrWord.isLeft()) {
      return Left(Helper.getLeft(failureOrWord));
    }

    return Right(success);
  }
}

class ReadWord {
  final WordRepository wordRepository;

  ReadWord(this.wordRepository);

  Future<Either<Failure, Word>> call(Word word) async {
    final failureOrWord = await this.wordRepository.readWord(word);
    return failureOrWord.fold((failure) => Left(failure), (word) => Right(word));
  }
}

class WriteWord {
  final WordRepository wordRepository;

  WriteWord(this.wordRepository);

  Future<Either<Failure, Word>> call(Word word) async {
    if (word.englishText.length <= 0) {
      return Left(ValidationFailure(message: "english text is required", word: word));
    }
    if (word.spanishText.length <= 0) {
      return Left(ValidationFailure(message: "spanish text is required", word: word));
    }
    if (word.category.length <= 0) {
      return Left(ValidationFailure(message: "category is required", word: word));
    }

    if (word.createDate == 0) word.createDate = Helper.getTimestamp();
    word.modifyDate = Helper.getTimestamp();

    final failureOrWord = await this.wordRepository.writeWord(word);
    return failureOrWord.fold((failure) => Left(failure), (word) => Right(word));
  }
}

class DeleteWord {
  final WordRepository wordRepository;

  DeleteWord(this.wordRepository);

  Future<Either<Failure, bool>> call(Word word) async {
    if (word.id.length <= 0) {
      return Left(ValidationFailure(message: "the selected word is required", word: word));
    }

    final failureOrWord = await this.wordRepository.deleteWord(word);
    return failureOrWord.fold((failure) => Left(failure), (word) => Right(true));
  }
}

class Import {
  final WordRepository wordRepository;

  Import(this.wordRepository);

  Future<Either<Failure, bool>> call(String data) async {
    if (data.length <= 0) {
      return Left(ValidationFailure(message: "the data is required"));
    }

    final failureOrResult = await this.wordRepository.import(data);
    return failureOrResult.fold((failure) => Left(failure), (result) => Right(result));
  }
}

class Export {
  final WordRepository wordRepository;

  Export(this.wordRepository);

  Future<Either<Failure, String>> call() async {
    final failureOrData = await this.wordRepository.export();
    return failureOrData.fold((failure) => Left(failure), (data) => Right(data));
  }
}
