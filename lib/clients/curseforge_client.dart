import 'dart:io' show Platform;

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../util/paged_list.dart';
import '../util/version.dart';
import 'curseforge_models.dart';
import 'curseforge_responses.dart';

class CurseForgeClient {
  static var logger = Logger();
  late Dio _dio;
  String _apiKey = "";

  static const String baseUrl = "https://api.curseforge.com";
  static const int gameIdMinecraft = 432;
  static const int classIdMods = 6;

  CurseForgeClient({String? apiKey}) {
    // 初始化Dio
    _dio = Dio();

    // 获取ApiKey
    if (apiKey != null && apiKey.isNotEmpty) {
      _apiKey = apiKey;
    } else {
      // 从环境变量加载
      var envVars = Platform.environment;
      _apiKey = envVars["CURSE_FORGE_API_KEY"] ?? "";
      logger.i("从环境变量获取apiKey=$_apiKey");
    }

    // Json转换设置
    JsonMapper().useAdapter(_enumAdapter);
  }

  JsonMapperAdapter get _enumAdapter {
    return JsonMapperAdapter(enumValues: {
      ModStatus: ModStatus.descriptor,
    });
  }

  Options? buildOptions([ResponseType? responseType = ResponseType.plain]) {
    var headers = <String, dynamic>{};
    if (_apiKey != "") headers["x-api-key"] = _apiKey;
    return Options(headers: headers, responseType: responseType);
  }

  Future<List<Versions>> getVersions([int gameId = gameIdMinecraft]) async {
    var url = "$baseUrl/v1/games/$gameId/versions";
    var resp = await _dio.get(url, options: buildOptions());
    var respJson = resp.data as String;
    var respBody = JsonMapper.deserialize<VersionsResponse>(respJson);
    return (respBody != null) ? respBody.data : [];
  }

  Future<List<VersionType>> getVersionTypes([
    int gameId = gameIdMinecraft,
  ]) async {
    var url = "$baseUrl/v1/games/$gameId/version-types";
    var resp = await _dio.get(url, options: buildOptions());
    var respJson = resp.data as String;
    var respBody = JsonMapper.deserialize<VersionTypesResponse>(respJson);
    return (respBody != null) ? respBody.data : [];
  }

  int _compareVersion(String left, String right) {
    var leftVersion = Version(left);
    var rightVersion = Version(right);
    return -leftVersion.compareTo(rightVersion);
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

  Future<List<VersionTypeInfo>> getVersionTypeInfos() async {
    var versionsList = await getVersions();
    var versionsMap = <int, List<String>>{};
    int versionsAmount = 0;
    for (var vs in versionsList) {
      versionsMap[vs.type] = vs.versions;
      versionsAmount += vs.versions.length;
    }
    logger.d("Get Versions 接口调用完成！");
    logger.d("版本类型数量：${versionsList.length}");
    logger.d("版本总数：$versionsAmount");

    var types = await getVersionTypes();
    logger.d("Get Version Types 接口调用完成！");
    logger.d("版本类型数量：${types.length}");

    var infos = <VersionTypeInfo>[];
    for (var vt in types) {
      var versions = versionsMap[vt.id];
      if (versions == null) {
        logger.w("无效的版本类型ID：${vt.id}");
        continue;
      }
      if (vt.name.startsWith("Minecraft ")) {
        versions.sort(_compareVersion);
      }

      var info = VersionTypeInfo(vt, versions);
      infos.add(info);
    }
    logger.d("数据合并完成！");
    logger.i("版本类型信息数量：${infos.length}");

    infos.sort(_compareType);
    return infos;
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

    var resp = await _dio.get(
      url,
      queryParameters: params,
      options: buildOptions(),
    );
    var respJson = resp.data as String;
    var respBody = JsonMapper.deserialize<CategoriesResponse>(respJson);
    return (respBody != null) ? respBody.data : [];
  }

  Future<PagedList<Mod>> searchMods({
    int gameId = gameIdMinecraft,
    int? classId,
    int? categoryId,
    String? gameVersion,
    String? searchFilter,
    ModsSearchSortField? sortField,
    ModsSearchSortOrder? sortOrder,
    ModLoaderType? modLoaderType,
    int? gameVersionTypeId,
    String? slug,
    int? index,
    int? pageSize,
  }) async {
    String url = "$baseUrl/v1/mods/search";
    var params = <String, dynamic>{"gameId": gameId};
    if (classId != null) params["classId"] = classId;
    if (categoryId != null) params["categoryId"] = categoryId;
    if (gameVersion != null) params["gameVersion"] = gameVersion;
    if (searchFilter != null) params["searchFilter"] = searchFilter;
    if (sortField != null) params["sortField"] = sortField.value;
    if (sortOrder != null) params["sortOrder"] = sortOrder.value;
    if (modLoaderType != null) params["modLoaderType"] = modLoaderType.index;
    if (gameVersionTypeId != null) {
      params["gameVersionTypeId"] = gameVersionTypeId;
    }
    if (slug != null) params["slug"] = slug;
    if (index != null) params["index"] = index;
    if (pageSize != null && pageSize > 0 && pageSize <= 50) {
      params["pageSize"] = pageSize;
    }

    var resp = await _dio.get(
      url,
      queryParameters: params,
      options: buildOptions(),
    );
    var respJson = resp.data as String;
    var respBody = JsonMapper.deserialize<SearchModsResponse>(respJson);
    if (respBody != null) {
      var page = respBody.pagination;
      return PagedList(
        page.index,
        page.pageSize,
        page.totalCount,
        respBody.data,
      );
    }
    return PagedList<Mod>.none();
  }

  Future<Mod?> getMod(int modId) async {
    var url = "$baseUrl/v1/mods/$modId";
    var resp = await _dio.get(url, options: buildOptions());
    var respJson = resp.data as String;
    var respBody = JsonMapper.deserialize<ModResponse>(respJson);
    return respBody?.data;
  }

  Future<ModFile?> getModFile(int modId, int fileId) async {
    var url = "$baseUrl/v1/mods/$modId/files/$fileId";
    var resp = await _dio.get(url, options: buildOptions());
    var respJson = resp.data as String;
    var respBody = JsonMapper.deserialize<ModFileResponse>(respJson);
    return respBody?.data;
  }

  Future<PagedList<ModFile>> getModFiles(
    int modId, {
    String? gameVersion,
    int? modLoaderType,
    int? gameVersionTypeId,
    int? index,
    int? pageSize,
  }) async {
    var url = "$baseUrl/v1/mods/$modId/files";
    var params = <String, dynamic>{};
    if (gameVersion != null) params["gameVersion"] = gameVersion;
    if (modLoaderType != null) params["gameVersion"] = modLoaderType;
    if (gameVersionTypeId != null) params["gameVersion"] = gameVersionTypeId;
    if (index != null) params["index"] = index;
    if (pageSize != null && pageSize > 0 && pageSize <= 50) {
      params["pageSize"] = pageSize;
    }

    var resp = await _dio.get(
      url,
      queryParameters: params,
      options: buildOptions(),
    );
    var respJson = resp.data as String;
    var respBody = JsonMapper.deserialize<ModFilesResponse>(respJson);
    if (respBody != null) {
      var page = respBody.pagination;
      return PagedList(
        page.index,
        page.pageSize,
        page.totalCount,
        respBody.data,
      );
    }
    return PagedList.none();
  }
}
