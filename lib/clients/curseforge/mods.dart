import 'categories.dart';
import 'mod_files.dart';

class Mod {
  late int id;
  late int gameId;
  late String name;
  late String slug;
  late Map<String, String?> links;
  late String summary;
  late int status;
  late int downloadCount;
  late bool isFeatured;
  late int primaryCategoryId;
  late List<Category> categories;
  int? classId;
  late List<ModAuthor> authors;
  late ModAsset logo;
  late List<ModAsset> screenshots;
  late int mainFileId;
  late List<ModFile> latestFiles;
  late List<FileIndex> latestFilesIndexes;
  late String dateCreated;
  late String dateModified;
  late String dateReleased;
  bool? allowModDistribution;
  late int gamePopularityRank;
  late bool isAvailable;
  late int thumbsUpCount;

  Mod.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    gameId = json["gameId"] as int;
    name = json["name"] as String;
    slug = json["slug"] as String;
    // links 见下方
    summary = json["summary"] as String;
    status = json["status"] as int;
    downloadCount = json["downloadCount"] as int;
    isFeatured = json["isFeatured"] as bool;
    primaryCategoryId = json["primaryCategoryId"] as int;
    // categories 见下方
    classId = json["classId"] as int?;
    // authors 见下方
    // logo 见下方
    // screenshots 见下方
    mainFileId = json["mainFileId"] as int;
    // latestFiles 见下方
    // latestFileIndexes 见下方
    dateCreated = json["dateCreated"] as String;
    dateModified = json["dateModified"] as String;
    dateReleased = json["dateReleased"] as String;
    allowModDistribution = json["allowModDistribution"] as bool?;
    gamePopularityRank = json["gamePopularityRank"] as int;
    isAvailable = json["isAvailable"] as bool;
    thumbsUpCount = json["thumbsUpCount"] as int;

    links = <String, String?>{};
    var linksMap = json["links"] as Map;
    for (var entry in linksMap.entries) {
      links[entry.key] = entry.value as String?;
    }

    categories = <Category>[];
    var list = json["categories"] as List;
    for (var categoryJson in list) {
      if (categoryJson is Map<String, dynamic>) {
        var category = Category.fromJson(categoryJson);
        categories.add(category);
      }
    }

    authors = <ModAuthor>[];
    list = json["authors"] as List;
    for (var authorJson in list) {
      if (authorJson is Map<String, dynamic>) {
        var author = ModAuthor.fromJson(authorJson);
        authors.add(author);
      }
    }

    var logoJson = json["logo"];
    if (logoJson is Map<String, dynamic>) {
      logo = ModAsset.fromJson(logoJson);
    }

    screenshots = <ModAsset>[];
    list = json["screenshots"] as List;
    for (var scrshotJson in list) {
      if (scrshotJson is Map<String, dynamic>) {
        var scrshot = ModAsset.fromJson(scrshotJson);
        screenshots.add(scrshot);
      }
    }

    latestFiles = <ModFile>[];
    list = json["latestFiles"] as List;
    for (var fileJson in list) {
      if (fileJson is Map<String, dynamic>) {
        var file = ModFile.fromJson(fileJson);
        latestFiles.add(file);
      }
    }

    latestFilesIndexes = <FileIndex>[];
    list = json["latestFilesIndexes"] as List;
    for (var idxJson in list) {
      if (idxJson is Map<String, dynamic>) {
        var idx = FileIndex.fromJson(idxJson);
        latestFilesIndexes.add(idx);
      }
    }
  }

  ModAuthor get mainAuthor => authors.first;

  @override
  String toString() {
    StringBuffer categories = StringBuffer();
    for (var cat in this.categories) {
      categories.write("[${cat.id}]");
    }
    return "#$id/@$slug [${mainAuthor.name}/$name] $summary {$categories}";
  }
}

class ModAuthor {
  late int id;
  late String name;
  late String url;

  ModAuthor.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    name = json["name"] as String;
    url = json["url"] as String;
  }

  @override
  String toString() {
    return "$id: $name";
  }
}

class ModAsset {
  late int id;
  late int modId;
  late String title;
  late String description;
  late String thumbnailUrl;
  late String url;

  ModAsset.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    modId = json["modId"] as int;
    title = json["title"] as String;
    description = json["description"] as String;
    thumbnailUrl = json["thumbnailUrl"] as String;
    url = json["url"] as String;
  }

  @override
  String toString() {
    return "$modId/$id: $title";
  }
}

class FileIndex {
  late String gameVersion;
  late int fileId;
  late String filename;
  late int releaseType;
  int? gameVersionTypeId;
  int? modLoader;

  FileIndex.fromJson(Map<String, dynamic> json) {
    gameVersion = json["gameVersion"] as String;
    fileId = json["fileId"] as int;
    filename = json["filename"] as String;
    releaseType = json["releaseType"] as int;
    gameVersionTypeId = json["gameVersionTypeId"] as int?;
    modLoader = json["modLoader"] as int?;
  }
}
