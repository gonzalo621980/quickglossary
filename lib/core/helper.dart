import 'package:dartz/dartz.dart';
import 'package:quickglossary/domain/entities/word.dart';

class Helper {
  static int getTimestamp({DateTime date = null}) {
    if (date != null)
      return (date.millisecondsSinceEpoch ~/ 1000);
    else
      return (DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  static Future<Either<L, R>> setRight<L, R>(R Function() functionRight) async {
    return Right(functionRight());
  }

  static Future<Either<L, R>> setLeft<L, R>(L Function() functionLeft) async {
    return Left(functionLeft());
  }

  static R getRight<L, R>(Either<L, R> resultRight) {
    R value = resultRight.fold(
        (l) => throw Exception("Expected Right value, but got Left: $l"), // Handle Left case
        (r) => r // Return the Right value
        );
    return value;
  }

  static L getLeft<L, R>(Either<L, R> resultLeft) {
    L value = resultLeft.fold(
        (l) => l, // Return the Right value
        (r) => throw Exception("Expected Left value, but got Right: $r") // Handle Left case
        );
    return value;
  }

  static int getScore(Word word) {
    int score = 1;
    int today = Helper.getTimestamp();
    int createDays = (today - word.createDate) ~/ (60 / 60 / 24);
    int modifyDays = (today - word.modifyDate) ~/ (60 / 60 / 24);
    int level = word.failureCount == 0 ? 100 : (word.successCount * 100) ~/ word.failureCount;

    int scoreCreateDays = createDays < 1
        ? 10
        : createDays < 7
            ? 5
            : createDays < 30
                ? 3
                : createDays < 365
                    ? 1
                    : 0;
    int scoreModifyDays = modifyDays < 1
        ? 0
        : modifyDays < 7
            ? 1
            : modifyDays < 30
                ? 3
                : modifyDays < 365
                    ? 5
                    : 10;
    int scoreContinuousSuccessCount = word.continuousSuccessCount == 0
        ? 50
        : word.continuousSuccessCount < 5
            ? 25
            : word.continuousSuccessCount < 10
                ? 10
                : 0;
    int scoreSuccess = 50 * (100 - level);

    score += (scoreCreateDays + scoreModifyDays + scoreContinuousSuccessCount + scoreSuccess);

    return score;
  }
}
