import 'package:quickglossary/domain/entities/word.dart';
// import 'package:equatable/equatable.dart';

class WordModel {
  static Word fromJson(dynamic json) {
    Word obj = new Word(
        id: json["id"],
        englishText: json["englishText"],
        spanishText: json["spanishText"],
        pronunciation: json["pronunciation"],
        definition: json["definition"],
        category: json["category"],
        continuousSuccessCount: json["continuousSuccessCount"],
        successCount: json["successCount"],
        failureCount: json["failureCount"],
        createDate: json["createDate"],
        modifyDate: json["modifyDate"]);

    return obj;
  }

  static dynamic toJson(Word obj) {
    return {
      "id": obj.id,
      "englishText": obj.englishText,
      "spanishText": obj.spanishText,
      "pronunciation": obj.pronunciation,
      "definition": obj.definition,
      "category": obj.category,
      "continuousSuccessCount": obj.continuousSuccessCount,
      "successCount": obj.successCount,
      "failureCount": obj.failureCount,
      "createDate": obj.createDate,
      "modifyDate": obj.modifyDate
    };
  }
}
