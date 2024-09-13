import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickglossary/data/models/cached_data_model.dart';
import 'package:quickglossary/domain/entities/cached_data.dart';

abstract class LocalDataSource {
  Future<CachedData> getData();
  Future<bool> setData(CachedData data);
  Future<void> clearData();
  Future<void> importData(String jsonString);
  Future<String> exportData();
}

class LocalDataSourceLocal extends LocalDataSource {
  static const CACHED_TOKEN = 'CACHED_TOKEN';
  static const CACHED_DATA = 'CACHED_DATA';

  final SharedPreferences sharedPreferences;

  LocalDataSourceLocal({@required this.sharedPreferences});

  @override
  Future<CachedData> getData() {
    final jsonString = sharedPreferences.getString(CACHED_DATA);
    if (jsonString == null) {
      CachedData data = new CachedData();
      this.setData(data);
      return Future.value(data);
    }
    return Future.value(CachedDataModel.fromJson(json.decode(jsonString)));
  }

  @override
  Future<bool> setData(CachedData data) {
    return sharedPreferences.setString(CACHED_DATA, json.encode(CachedDataModel.toJson(data)));
  }

  @override
  Future<void> clearData() {
    return sharedPreferences.remove(CACHED_DATA);
  }

  @override
  Future<void> importData(String jsonString) {
    sharedPreferences.setString(CACHED_DATA, jsonString);
    return Future.value();
  }

  @override
  Future<String> exportData() {
    final jsonString = sharedPreferences.getString(CACHED_DATA);
    return Future.value(jsonString);
  }
}
