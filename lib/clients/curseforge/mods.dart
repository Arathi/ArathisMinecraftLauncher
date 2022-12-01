import 'categories.dart';

class Mod {
  late int id;
  late int gameId;
  late String name;
  late String slug;
  // dynamic links;
  late String summary;
  // dynamic status;
  late int downloadCount;
  // late bool isFeatured;
  late int primaryCategoryId;
  late List<Category> categories;
  int? classId;
  late List<Author> authors;
  late Asset logo;
  // late List<dynamic> screenshots;
  late int mainFileId;
  // late List<dynamic> latestFiles;
  // late List<dynamic> latestFilesIndexes;
  late String dateCreated;
  late String dateModified;
  late String dateReleased;
  bool? allowModDistribution;
  late int gamePopularityRank;
  late bool isAvailable;

  Mod.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    gameId = json["gameId"] as int;
    name = json["name"] as String;
    slug = json["slug"] as String;
    summary = json["summary"] as String;
    downloadCount = json["downloadCount"] as int;
    primaryCategoryId = json["primaryCategoryId"] as int;
    classId = json["classId"] as int?;
    mainFileId = json["mainFileId"] as int;
    dateCreated = json["dateCreated"] as String;
    dateModified = json["dateModified"] as String;
    dateReleased = json["dateReleased"] as String;
    allowModDistribution = json["allowModDistribution"] as bool?;
    gamePopularityRank = json["gamePopularityRank"] as int;
    isAvailable = json["isAvailable"] as bool;

    categories = <Category>[];
    var list = json["categories"] as List;
    for (var categoryJson in list) {
      if (categoryJson is Map<String, dynamic>) {
        var category = Category.fromJson(categoryJson);
        categories.add(category);
      }
    }

    authors = <Author>[];
    list = json["authors"] as List;
    for (var authorJson in list) {
      if (authorJson is Map<String, dynamic>) {
        var author = Author.fromJson(authorJson);
        authors.add(author);
      }
    }

    var logoJson = json["logo"];
    if (logoJson is Map<String, dynamic>) {
      logo = Asset.fromJson(logoJson);
    }
  }

  Author get mainAuthor => authors.first;

  @override
  String toString() {
    StringBuffer categories = StringBuffer();
    for (var cat in this.categories) {
      categories.write("[${cat.id}]");
    }
    return "#$id/@$slug [${mainAuthor.name}/$name] $summary {$categories}";
  }
}

class Author {
  late int id;
  late String name;
  late String url;

  Author.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    name = json["name"] as String;
    url = json["url"] as String;
  }

  @override
  String toString() {
    return "$id: $name";
  }
}

class Asset {
  late int id;
  late int modId;
  late String title;
  late String description;
  late String thumbnailUrl;
  late String url;

  Asset.fromJson(Map<String, dynamic> json) {
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
