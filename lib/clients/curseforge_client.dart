import 'package:dio/dio.dart';
import 'dart:io' show Platform;

import 'curseforge/versions.dart';
import 'curseforge/categories.dart';
import 'curseforge/mods.dart';
import 'curseforge/mod_files.dart';

import '../util/version.dart';

class CurseForgeClient {
  late Dio _dio;
  String _apiKey = "";

  static const String baseUrl = "https://api.curseforge.com";
  static const int gameIdMinecraft = 432;
  static const int classIdMods = 6;

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

  void parseDataAsList(
    Response resp,
    Function(Map<String, dynamic>) listElementBuilder,
  ) {
    if (resp.statusCode != null && resp.statusCode == 200) {
      if (resp.data is Map<String, dynamic>) {
        var data = resp.data["data"];
        if (data is List<dynamic>) {
          for (var json in data) {
            if (json is Map<String, dynamic>) {
              listElementBuilder(json);
            }
          }
        }
      }
    }
  }

  void parseData(
    Response resp,
    Function(Map<String, dynamic>) dataBuilder,
  ) {
    if (resp.statusCode != null && resp.statusCode == 200) {
      if (resp.data is Map<String, dynamic>) {
        var dataJson = resp.data["data"];
        if (dataJson is Map<String, dynamic>) {
          dataBuilder(dataJson);
        }
      }
    }
  }

  Future<List<Versions>> getVersions([int gameId = gameIdMinecraft]) async {
    var url = "$baseUrl/v1/games/$gameId/versions";
    var resp = await _dio.get(url, options: _options);

    var versionsList = <Versions>[];
    parseDataAsList(resp, (json) {
      var vs = Versions.fromJson(json);
      versionsList.add(vs);
    });

    return versionsList;
  }

  Future<List<VersionType>> getVersionTypes([
    int gameId = gameIdMinecraft,
  ]) async {
    var url = "$baseUrl/v1/games/$gameId/version-types";
    var resp = await _dio.get(url, options: _options);

    var types = <VersionType>[];
    parseDataAsList(resp, (json) {
      var vt = VersionType.fromJson(json);
      types.add(vt);
    });

    return types;
  }

  Future<List<VersionTypeInfo>> getVersionTypeInfos() async {
    var versionsList = await getVersions();
    var versionsMap = <int, List<String>>{};
    int versionsAmount = 0;
    for (var vs in versionsList) {
      versionsMap[vs.type] = vs.versions;
      versionsAmount += vs.versions.length;
    }
    print("Get Versions 接口调用完成！");
    print("版本类型数量：${versionsList.length}");
    print("版本总数：$versionsAmount");

    var types = await getVersionTypes();
    print("Get Version Types 接口调用完成！");
    print("版本类型数量：${types.length}");

    var infos = <VersionTypeInfo>[];
    for (var vt in types) {
      var versions = versionsMap[vt.id];
      if (versions == null) {
        print("无效的版本类型ID：${vt.id}");
        continue;
      }
      if (vt.name.startsWith("Minecraft ")) {
        versions.sort(_compareVersion);
      }

      var info = VersionTypeInfo(vt, versions);
      infos.add(info);
    }
    print("数据合并完成！");
    print("版本类型信息数量：${infos.length}");

    infos.sort(_compareType);
    return infos;
  }

  int _compareType(VersionTypeInfo left, VersionTypeInfo right) {
    if (left.name.startsWith("Minecraft ") &&
        right.name.startsWith("Minecraft ")) {
      var leftVersion = Version(left.name.substring(10));
      var rightVersion = Version(right.name.substring(10));
      return -leftVersion.compareTo(rightVersion);
    } else if (left.name.startsWith("Minecraft ") &&
        !right.name.startsWith("Minecraft ")) {
      return -1;
    } else if (!left.name.startsWith("Minecraft ") &&
        right.name.startsWith("Minecraft ")) {
      return 1;
    }
    return left.name.compareTo(right.name);
  }

  int _compareVersion(String left, String right) {
    var leftVersion = Version(left);
    var rightVersion = Version(right);
    return -leftVersion.compareTo(rightVersion);
  }

  Future<List<Category>> getCategories({
    int gameId = gameIdMinecraft,
    int? classId,
    bool? classesOnly,
  }) async {
    var url = "$baseUrl/v1/categories";
    var params = <String, dynamic>{"gameId": gameId};
    if (classId != null) params["classId"] = classId;
    if (classesOnly != null) params["classesOnly"] = classesOnly;

    var resp = await _dio.get(url, queryParameters: params, options: _options);

    var categories = <Category>[];
    parseDataAsList(resp, (json) {
      var cat = Category.fromJson(json);
      categories.add(cat);
    });

    return categories;
  }

  Future<List<Mod>> searchMods({
    int gameId = gameIdMinecraft,
    int? classId,
    int? categoryId,
    String? gameVersion,
    String? searchFilter,
    int? sortField,
    String? sortOrder,
    int? modLoaderType,
    int? gameVersionTypeId,
    String? slug,
  }) async {
    String url = "$baseUrl/v1/mods/search";
    var params = <String, dynamic>{"gameId": gameId};
    if (classId != null) params["classId"] = classId;
    if (categoryId != null) params["categoryId"] = categoryId;
    if (gameVersion != null) params["gameVersion"] = gameVersion;
    if (searchFilter != null) params["searchFilter"] = searchFilter;
    if (sortField != null) params["sortField"] = sortField;
    if (sortOrder != null) params["sortOrder"] = sortOrder;
    if (modLoaderType != null) params["modLoaderType"] = modLoaderType;
    if (gameVersionTypeId != null) {
      params["gameVersionTypeId"] = gameVersionTypeId;
    }
    if (slug != null) params["slug"] = slug;

    var mods = <Mod>[];
    var resp = await _dio.get(url, queryParameters: params, options: _options);
    parseDataAsList(resp, (json) {
      var mod = Mod.fromJson(json);
      mods.add(mod);
    });

    return mods;
  }

  Future<Mod?> getMod(int modId) async {
    var url = "$baseUrl/v1/mods/$modId";
    var resp = await _dio.get(url, options: _options);
    Mod? mod;
    parseData(resp, (json) => mod = Mod.fromJson(json));
    return mod;
  }

  Future<ModFile?> getModFile(int modId, int fileId) async {
    var url = "$baseUrl/v1/mods/$modId/files/$fileId";
    var resp = await _dio.get(url, options: _options);
    ModFile? modFile;
    parseData(resp, (json) => modFile = ModFile.fromJson(json));
    return modFile;
  }

  Future<List<ModFile>> getModFiles(
    int modId, {
    String? gameVersion,
    int? modLoaderType,
    int? gameVersionTypeId,
  }) async {
    var url = "$baseUrl/v1/mods/$modId/files";
    var params = <String, dynamic>{};
    if (gameVersion != null) params["gameVersion"] = gameVersion;
    if (modLoaderType != null) params["gameVersion"] = modLoaderType;
    if (gameVersionTypeId != null) params["gameVersion"] = gameVersionTypeId;

    var resp = await _dio.get(url, queryParameters: params, options: _options);
    var files = <ModFile>[];
    parseDataAsList(resp, (json) {
      var mf = ModFile.fromJson(json);
      files.add(mf);
    });

    return files;
  }

  // getFiles() {}
}
