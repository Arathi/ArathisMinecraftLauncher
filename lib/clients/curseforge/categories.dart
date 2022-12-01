class Category {
  late int id;
  late int gameId;
  late String name;
  late String slug;
  late String url;
  late String iconUrl;
  late String dateModified;
  bool? isClass;
  int? classId;
  int? parentCategoryId;
  int? displayIndex;

  Category.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    gameId = json["gameId"] as int;
    name = json["name"] as String;
    slug = json["slug"] as String;
    url = json["url"] as String;
    iconUrl = json["iconUrl"] as String;
    dateModified = json["dateModified"] as String;
    isClass = json["isClass"] as bool?;
    classId = json["classId"] as int?;
    parentCategoryId = json["parentCategoryId"] as int?;
    displayIndex = json["displayIndex"] as int?;
  }

  @override
  String toString() {
    return "#$id/@$slug - [$name]";
  }
}
