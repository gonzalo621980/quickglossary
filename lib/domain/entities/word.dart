import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';

class Word extends Equatable {
  String id;
  String englishText;
  String spanishText;
  String category;
  String pronunciation;
  String definition;
  int continuousSuccessCount;
  int successCount;
  int failureCount;
  int createDate;
  int modifyDate;

  Word(
      {this.id = "",
      this.englishText = "",
      this.spanishText = "",
      this.category = "",
      this.pronunciation = "",
      this.definition = "",
      this.continuousSuccessCount = 0,
      this.successCount = 0,
      this.failureCount = 0,
      this.createDate = 0,
      this.modifyDate = 0})
      : super([
          id,
          englishText,
          spanishText,
          category,
          pronunciation,
          definition,
          continuousSuccessCount,
          successCount,
          failureCount,
          createDate,
          modifyDate
        ]);
}
