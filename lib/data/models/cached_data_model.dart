// import 'package:equatable/equatable.dart';
import 'package:quickglossary/domain/entities/cached_data.dart';
import 'package:quickglossary/domain/entities/word.dart';
import 'package:quickglossary/data/models/word_model.dart';

class CachedDataModel {
  static CachedData fromJson(Map<String, dynamic> json) {
    CachedData obj = new CachedData();

    obj.listWords = [];
    if (json["listWords"] != null) {
      json["listWords"].forEach((jWord) {
        Word oWord = WordModel.fromJson(jWord);
        obj.listWords.add(oWord);
      });
    }

    return obj;
  }

  static Map<String, dynamic> toJson(CachedData obj) {
    Map<String, dynamic> json = new Map<String, dynamic>();

    List<dynamic> listWords = [];
    if (obj.listWords != null) {
      obj.listWords.forEach((oWord) {
        dynamic jWord = WordModel.toJson(oWord);
        listWords.add(jWord);
      });
    }
    json.putIfAbsent("listWords", () => listWords);

    return json;
  }
}
