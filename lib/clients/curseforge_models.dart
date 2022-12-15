// ignore_for_file: constant_identifier_names

import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class Links {
  @JsonProperty(name: 'websiteUrl')
  String? websiteUrl;

  @JsonProperty(name: 'wikiUrl')
  String? wikiUrl;

  @JsonProperty(name: 'issuesUrl')
  String? issuesUrl;

  @JsonProperty(name: 'sourceUrl')
  String? sourceUrl;

  Links(this.websiteUrl, this.wikiUrl, this.issuesUrl, this.sourceUrl);
}

@jsonSerializable
class Category {
  @JsonProperty(name: 'id')
  int id;

  @JsonProperty(name: 'gameId')
  int gameId;

  @JsonProperty(name: 'name')
  String name;

  @JsonProperty(name: 'slug')
  String? slug;

  @JsonProperty(name: 'url')
  String url;

  @JsonProperty(name: 'iconUrl')
  String iconUrl;

  @JsonProperty(name: 'dateModified')
  String dateModified;

  @JsonProperty(name: 'isClass')
  bool? isClass;

  @JsonProperty(name: 'classId')
  int? classId;

  @JsonProperty(name: 'parentCategoryId')
  int? parentCategoryId;

  @JsonProperty(name: 'displayIndex')
  int? displayIndex;

  Category(
    this.id,
    this.gameId,
    this.name,
    this.slug,
    this.url,
    this.iconUrl,
    this.dateModified,
    this.isClass,
    this.classId,
    this.parentCategoryId,
    this.displayIndex,
  );

  @override
  String toString() {
    return "#$id/@$slug - [$name]";
  }
}

@jsonSerializable
class ModAuthor {
  @JsonProperty(name: 'id')
  int id;

  @JsonProperty(name: 'name')
  String name;

  @JsonProperty(name: 'url')
  String url;

  ModAuthor(
    this.id,
    this.name,
    this.url,
  );

  @override
  String toString() => "#$id $name $url";
}

@jsonSerializable
class ModAsset {
  @JsonProperty(name: 'id')
  int id;

  @JsonProperty(name: 'modId')
  int modId;

  @JsonProperty(name: 'title')
  String title;

  @JsonProperty(name: 'description')
  String description;

  @JsonProperty(name: 'thumbnailUrl')
  String thumbnailUrl;

  @JsonProperty(name: 'url')
  String url;

  ModAsset(
    this.id,
    this.modId,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.url,
  );

  @override
  String toString() => "#$modId/$id $title";
}

@jsonSerializable
class FileHash {
  static const int sha1 = 1;
  static const int md5 = 2;

  @JsonProperty(name: 'value')
  String value;

  @JsonProperty(name: 'algo')
  int algo;

  FileHash(this.value, this.algo);

  @override
  String toString() {
    var algoName = "其他";
    switch (algo) {
      case sha1:
        algoName = "SHA-1";
        break;
      case md5:
        algoName = "MD5";
        break;
    }
    return "$algoName - $value";
  }
}

@jsonSerializable
class FileDependency {
  @JsonProperty(name: 'modId')
  int modId;

  @JsonProperty(name: 'relationType')
  int relationType;

  FileDependency(this.modId, this.relationType);

  @override
  String toString() {
    String relation = "其他依赖";
    switch (relationType) {
      case 1:
        relation = "嵌入库";
        break;
      case 2:
        relation = "可选依赖";
        break;
      case 3:
        relation = "必须依赖";
        break;
      case 4:
        relation = "工具";
        break;
      case 5:
        relation = "不兼容";
        break;
      case 6:
        relation = "包含";
        break;
    }
    return "$relation $modId";
  }
}

@jsonSerializable
class ModFile {
  @JsonProperty(name: 'id')
  int id;

  @JsonProperty(name: 'gameId')
  int gameId;

  @JsonProperty(name: 'modId')
  int modId;

  @JsonProperty(name: 'isAvailable')
  bool isAvailable;

  @JsonProperty(name: 'displayName')
  String displayName;

  @JsonProperty(name: 'fileName')
  String fileName;

  @JsonProperty(name: 'releaseType')
  int releaseType;

  @JsonProperty(name: 'fileStatus')
  int fileStatus;

  @JsonProperty(name: 'hashes')
  List<FileHash> hashes;

  @JsonProperty(name: 'fileDate')
  String fileDate;

  @JsonProperty(name: 'fileLength')
  int fileLength;

  @JsonProperty(name: 'downloadCount')
  int downloadCount;

  @JsonProperty(name: 'downloadUrl')
  String? downloadUrl;

  @JsonProperty(name: 'gameVersions')
  List<String> gameVersions;

  // @JsonProperty(name: 'value')
  // sortableGameVersions;

  @JsonProperty(name: 'dependencies')
  List<FileDependency> dependencies;

  @JsonProperty(name: 'exposeAsAlternative')
  bool? exposeAsAlternative;

  @JsonProperty(name: 'parentProjectFileId')
  int? parentProjectFileId;

  @JsonProperty(name: 'alternateFileId')
  int? alternateFileId;

  @JsonProperty(name: 'isServerPack')
  bool? isServerPack;

  @JsonProperty(name: 'serverPackFileId')
  int? serverPackFileId;

  @JsonProperty(name: 'fileFingerprint')
  int? fileFingerprint;

  // @JsonProperty(name: 'value')
  // late List<FileModule> modules;

  ModFile(
    this.id,
    this.gameId,
    this.modId,
    this.isAvailable,
    this.displayName,
    this.fileName,
    this.releaseType,
    this.fileStatus,
    this.hashes,
    this.fileDate,
    this.fileLength,
    this.downloadCount,
    this.downloadUrl,
    this.gameVersions,
    this.dependencies,
    this.exposeAsAlternative,
    this.parentProjectFileId,
    this.alternateFileId,
    this.isServerPack,
    this.fileFingerprint,
  );

  @override
  String toString() {
    return "#$modId/$id $displayName";
  }
}

@jsonSerializable
class FileIndex {
  @JsonProperty(name: 'gameVersion')
  String gameVersion;

  @JsonProperty(name: 'fileId')
  int fileId;

  @JsonProperty(name: 'filename')
  String filename;

  @JsonProperty(name: 'releaseType')
  int releaseType;

  @JsonProperty(name: 'gameVersionTypeId')
  int? gameVersionTypeId;

  @JsonProperty(name: 'modLoader')
  int? modLoader;

  FileIndex(
    this.gameVersion,
    this.fileId,
    this.filename,
    this.releaseType,
    this.gameVersionTypeId,
    this.modLoader,
  );
}

@jsonSerializable
enum ModStatus {
  New(1),
  ChangesRequired(2),
  UnderSoftReview(3),
  Approved(4),
  Rejected(5),
  ChangesMade(6),
  Inactive(7),
  Abandoned(8),
  Deleted(9),
  UnderReview(10);

  final int value;
  const ModStatus(this.value);

  static EnumDescriptor get descriptor {
    var mapping = <ModStatus, int>{};
    for (var modStatus in values) {
      mapping[modStatus] = modStatus.value;
    }
    return EnumDescriptor(values: values, mapping: mapping);
  }
}

@jsonSerializable
class Mod {
  @JsonProperty(name: "id")
  int id;

  @JsonProperty(name: "gameId")
  int gameId;

  @JsonProperty(name: "name")
  String name;

  @JsonProperty(name: "slug")
  String slug;

  @JsonProperty(name: "links")
  Links links;

  @JsonProperty(name: "summary")
  String summary;

  @JsonProperty(name: "status")
  ModStatus status;

  @JsonProperty(name: "downloadCount")
  int downloadCount;

  @JsonProperty(name: "isFeatured")
  bool isFeatured;

  @JsonProperty(name: "primaryCategoryId")
  int primaryCategoryId;

  @JsonProperty(name: "categories")
  List<Category> categories;

  @JsonProperty(name: "classId")
  int? classId;

  @JsonProperty(name: "authors")
  List<ModAuthor> authors;

  @JsonProperty(name: "logo")
  ModAsset? logo;

  @JsonProperty(name: "screenshots")
  List<ModAsset> screenshots;

  @JsonProperty(name: "mainFileId")
  int mainFileId;

  @JsonProperty(name: "latestFiles")
  List<ModFile> latestFiles;

  // @JsonProperty(name: "latestFilesIndexes")
  // List<FileIndex> latestFilesIndexes;

  @JsonProperty(name: "dateCreated")
  String dateCreated;

  @JsonProperty(name: "dateModified")
  String dateModified;

  @JsonProperty(name: "dateReleased")
  String dateReleased;

  @JsonProperty(name: "allowModDistribution")
  bool? allowModDistribution;

  @JsonProperty(name: "gamePopularityRank")
  int gamePopularityRank;

  @JsonProperty(name: "isAvailable")
  bool isAvailable;

  @JsonProperty(name: "thumbsUpCount")
  int thumbsUpCount;

  @JsonProperty(ignore: true)
  ModAuthor get mainAuthor => authors.first;

  ModFile? get mainFile {
    for (var file in latestFiles) {
      if (file.id == mainFileId) {
        return file;
      }
    }
    return null;
  }

  Mod(
    this.id,
    this.gameId,
    this.name,
    this.slug,
    this.links,
    this.summary,
    this.status,
    this.downloadCount,
    this.isFeatured,
    this.primaryCategoryId,
    this.categories,
    this.classId,
    this.authors,
    this.logo,
    this.screenshots,
    this.mainFileId,
    this.latestFiles,
    // this.latestFilesIndexes,
    this.dateCreated,
    this.dateModified,
    this.dateReleased,
    this.allowModDistribution,
    this.gamePopularityRank,
    this.isAvailable,
    this.thumbsUpCount,
  );

  @override
  String toString() => "#$id/@$slug ${mainAuthor.name}/$name $summary";
}

@jsonSerializable
class Versions {
  int type;
  List<String> versions;

  Versions(this.type, this.versions);
}

@jsonSerializable
class VersionType {
  int id;
  int gameId;
  String name;
  String slug;

  VersionType(this.id, this.gameId, this.name, this.slug);
}

class VersionTypeInfo {
  int id;
  String name;
  String slug;
  List<String> versions;

  VersionTypeInfo(VersionType type, this.versions)
      : id = type.id,
        name = type.name,
        slug = type.slug;

  @override
  String toString() {
    return "#$id/@$slug: [$name] - ${versions.length} versions";
  }
}

@jsonSerializable
class Pagination {
  @JsonProperty(name: "index")
  int index;

  @JsonProperty(name: "pageSize")
  int pageSize;

  @JsonProperty(name: "resultCount")
  int resultCount;

  @JsonProperty(name: "totalCount")
  int totalCount;

  Pagination(
    this.index,
    this.pageSize,
    this.resultCount,
    this.totalCount,
  );
}

@jsonSerializable
enum ModLoaderType {
  Any,
  Forge,
  Cauldron,
  LiteLoader,
  Fabric,
  Quilt,
}

enum ModsSearchSortField {
  Featured(1),
  Popularity(2),
  LastUpdated(3),
  Name(4),
  Author(5),
  TotalDownloads(6),
  Category(7),
  GameVersion(8);

  final int value;
  const ModsSearchSortField(this.value);
}

enum ModsSearchSortOrder {
  asc("asc"),
  desc("desc");

  final String value;
  const ModsSearchSortOrder(this.value);
}
