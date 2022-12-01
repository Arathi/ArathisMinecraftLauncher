class Versions {
  late int type;
  late List<String> versions;

  Versions.fromJson(Map<String, dynamic> json) {
    type = json["type"] as int;

    versions = <String>[];
    var list = json["versions"] as List;
    for (var item in list) {
      if (item is String) {
        versions.add(item);
      }
    }
  }
}

class VersionType {
  late int id;
  late int gameId;
  late String name;
  late String slug;

  VersionType.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    gameId = json["gameId"] as int;
    name = json["name"] as String;
    slug = json["slug"] as String;
  }
}

class VersionTypeInfo {
  late int id;
  late String name;
  late String slug;
  late List<String> versions;

  VersionTypeInfo(VersionType type, this.versions) {
    id = type.id;
    name = type.name;
    slug = type.slug;
  }

  @override
  String toString() {
    return "#$id/@$slug: [$name] - ${versions.length} versions";
  }
}
