import 'package:quick_glossary/domain/entities/word.dart';

class CachedData {
  List<Word> listWords;

  CachedData() : super() {
    this.listWords = [];
  }

  destroy() {
    this.listWords.clear();
    this.listWords = null;
  }
}
