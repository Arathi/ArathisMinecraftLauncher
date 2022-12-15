import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'curseforge_models.dart';

@jsonSerializable
class BaseResponse<D> {
  D data;
  BaseResponse(this.data);
}

// GET /v1/games/{gameId}/versions
@jsonSerializable
class VersionsResponse extends BaseResponse<List<Versions>> {
  VersionsResponse(super.data);
}

// GET /v1/games/{gameId}/version-types
@jsonSerializable
class VersionTypesResponse extends BaseResponse<List<VersionType>> {
  VersionTypesResponse(super.data);
}

// GET /v1/categories
@jsonSerializable
class CategoriesResponse extends BaseResponse<List<Category>> {
  CategoriesResponse(super.data);
}

// GET /v1/mods/search
@jsonSerializable
class SearchModsResponse extends ModsResponse {
  Pagination pagination;
  SearchModsResponse(
    super.data,
    this.pagination,
  );
}

// GET /v1/mods/{modId}
@jsonSerializable
class ModResponse extends BaseResponse<Mod> {
  ModResponse(super.data);
}

// POST /v1/mods
@jsonSerializable
class ModsResponse extends BaseResponse<List<Mod>> {
  ModsResponse(super.data);
}

// GET /v1/mods/{modId}/files/{fileId}
@jsonSerializable
class ModFileResponse extends BaseResponse<ModFile> {
  ModFileResponse(super.data);
}

// GET /v1/mods/{modId}/files
@jsonSerializable
class ModFilesResponse extends BaseResponse<List<ModFile>> {
  Pagination pagination;
  ModFilesResponse(super.data, this.pagination);
}
