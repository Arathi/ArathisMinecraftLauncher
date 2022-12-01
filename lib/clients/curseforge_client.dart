import 'package:dio/dio.dart';
import 'dart:io' show Platform;

import 'curseforge/messages.dart';

class CurseForgeClient {
  late Dio _dio;
  String _apiKey = "";

  static const String baseUrl = "https://api.curseforge.com";
  static const int gameIdMinecraft = 432;
  static const int categoryIdMods = 6;

  CurseForgeClient({String? apiKey}) {
    _dio = Dio();
    if (apiKey != null && apiKey.isNotEmpty) {
      _apiKey = apiKey;
    } else {
      // 从环境变量加载
      var envVars = Platform.environment;
      _apiKey = envVars["CURSE_FORGE_API_KEY"] ?? "";
      print("从环境变量获取apiKey=$_apiKey");
    }
  }

  Options? get _options {
    return Options(headers: <String, dynamic>{"x-api-key": _apiKey});
  }

  Future<List<Versions>> getVersions([int gameId = gameIdMinecraft]) async {
    String url = "$baseUrl/v1/games/$gameId/versions";
    var resp = await _dio.get(url, options: _options);
    List<Versions> versionsList = <Versions>[];
    if (resp.statusCode != null && resp.statusCode == 200) {
      if (resp.data is Map<String, dynamic>) {
        var data = resp.data["data"];
        if (data is List<dynamic>) {
          for (var json in data) {
            if (json is Map<String, dynamic>) {
              Versions vs = Versions.fromJson(json);
              versionsList.add(vs);
            }
          }
        }
      }
    }
    return versionsList;
  }

  Future<List<VersionType>> getVersionTypes(
      [int gameId = gameIdMinecraft]) async {
    String url = "$baseUrl/v1/games/$gameId/version-types";
    var resp = await _dio.get(url, options: _options);
    List<VersionType> types = <VersionType>[];
    if (resp.statusCode != null && resp.statusCode == 200) {
      if (resp.data is Map<String, dynamic>) {
        var data = resp.data["data"];
        if (data is List<dynamic>) {
          for (var json in data) {
            if (json is Map<String, dynamic>) {
              VersionType vt = VersionType.fromJson(json);
              types.add(vt);
            }
          }
        }
      }
    }
    return types;
  }

  getCategories() {}

  searchMods() {}

  getMod() {}

  getMods() {}

  getModFile() {}

  getModFiles() {}

  getFiles() {}
}
