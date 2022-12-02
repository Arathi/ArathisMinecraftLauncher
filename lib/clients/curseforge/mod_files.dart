class ModFile {
  late int id;
  late int gameId;
  late int modId;
  late bool isAvailable;
  late String displayName;
  late String fileName;
  late int releaseType;
  late int fileStatus;
  late List<FileHash> hashes;
  late String fileDate;
  late int fileLength;
  late int downloadCount;
  String? downloadUrl;
  late List<String> gameVersions;
  // sortableGameVersions;
  late List<FileDependency> dependencies;
  bool? exposeAsAlternative;
  int? parentProjectFileId;
  int? alternateFileId;
  bool? isServerPack;
  int? serverPackFileId;
  int? fileFingerprint;
  late List<FileModule> modules;

  ModFile.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    gameId = json["gameId"] as int;
    modId = json["modId"] as int;
    isAvailable = json["isAvailable"] as bool;
    displayName = json["displayName"] as String;
    fileName = json["fileName"] as String;
    releaseType = json["releaseType"] as int;
    fileStatus = json["fileStatus"] as int;
    fileDate = json["fileDate"] as String;
    fileLength = json["fileLength"] as int;
    downloadCount = json["downloadCount"] as int;
    downloadUrl = json["downloadUrl"] as String?;
    exposeAsAlternative = json["exposeAsAlternative"] as bool?;
    parentProjectFileId = json["parentProjectFileId"] as int?;
    alternateFileId = json["alternateFileId"] as int?;
    isServerPack = json["isServerPack"] as bool?;
    serverPackFileId = json["serverPackFileId"] as int?;
    fileFingerprint = json["fileFingerprint"] as int?;

    hashes = <FileHash>[];
    var list = json["hashes"] as List;
    for (var hashJson in list) {
      if (hashJson is Map<String, dynamic>) {
        var hash = FileHash.fromJson(hashJson);
        hashes.add(hash);
      }
    }

    gameVersions = <String>[];
    list = json["gameVersions"] as List;
    for (var gv in list) {
      if (gv is String) {
        gameVersions.add(gv);
      }
    }

    dependencies = <FileDependency>[];
    list = json["dependencies"] as List;
    for (var depJson in list) {
      if (depJson is Map<String, dynamic>) {
        var dep = FileDependency.fromJson(depJson);
        dependencies.add(dep);
      }
    }

    modules = <FileModule>[];
    list = json["modules"] as List;
    for (var moduleJson in list) {
      if (moduleJson is Map<String, dynamic>) {
        var module = FileModule.fromJson(moduleJson);
        modules.add(module);
      }
    }
  }

  @override
  String toString() {
    return "#$modId/$id $displayName";
  }
}

class FileHash {
  static const int sha1 = 1;
  static const int md5 = 2;

  late String value;
  late int algo;

  FileHash.fromJson(Map<String, dynamic> json) {
    value = json["value"] as String;
    algo = json["algo"] as int;
  }

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

class FileDependency {
  late int modId;
  late int relationType;

  FileDependency.fromJson(Map<String, dynamic> json) {
    modId = json["modId"] as int;
    relationType = json["relationType"] as int;
  }

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

class FileModule {
  late String name;
  late int fingerprint;

  FileModule.fromJson(Map<String, dynamic> json) {
    name = json["name"] as String;
    fingerprint = json["fingerprint"] as int;
  }

  @override
  String toString() {
    return "$name - $fingerprint";
  }
}
