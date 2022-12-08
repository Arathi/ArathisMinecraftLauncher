import 'dart:io';
import 'dart:convert';

typedef JsonMap = Map<String, dynamic>;

class ArgumentRule {}

class Argument {
  List<ArgumentRule> rules = [];
  List<String> values = [];

  Argument.fromJson(Map<String, dynamic> json) {}
}

class AssetIndex {
  late String id;
  late String url;
  late String sha1;
  late int size;
  late int totalSize;

  AssetIndex.fromJson(JsonMap json) {
    totalSize = json["totalSize"] as int;
    id = json["id"] as String;
    url = json["url"] as String;
    sha1 = json["sha1"] as String;
    size = json["size"] as int;
  }
}

class Artifact {
  late String? path;
  late String url;
  late String sha1;
  late int size;

  Artifact.fromJson(JsonMap json) {
    path = json["path"] as String?;
    url = json["url"] as String;
    sha1 = json["sha1"] as String;
    size = json["size"] as int;
  }
}

class Library {
  late String name;
  late Artifact? artifact;
  late List<Rule>? rules;

  Library.fromJson(JsonMap json) {
    name = json["name"] as String;

    dynamic tmp = json["downloads"];
    if (tmp != null && tmp is JsonMap) {
      dynamic artifactJson = tmp["artifact"];
      if (artifactJson is JsonMap) {
        artifact = Artifact.fromJson(artifactJson);
      }
    }

    tmp = json["rules"];
    if (tmp != null && tmp is List) {
      rules = <Rule>[];
      for (var ruleJson in tmp) {
        if (ruleJson is JsonMap) {
          var rule = Rule.fromJson(ruleJson);
          rules!.add(rule);
        }
      }
    }
  }
}

class Rule {
  late String action;
  late Map<String, dynamic> conditions;

  Rule.fromJson(JsonMap json) {
    action = json["action"];
    conditions = <String, dynamic>{};
    for (var entry in json.entries) {
      if (entry.key == "action") continue;
      conditions[entry.key] = entry.value;
    }
  }
}

class VersionJson {
  String dir;

  String name;

  late String id;

  // 用于生成arguments
  late List<Argument> arguments;

  // 用于生成jvmArguments
  late List<Argument> jvmArguments;

  // 游戏本体包名（不带绝对路径，不带扩展名）
  // 用于生成classpath的最后一项
  late String jar;

  // 用于校验assets
  late AssetIndex assetIndex;

  // assets名称
  late String assets;

  // 用于检查jvm版本
  late JsonMap javaVersion;

  // 用于下载依赖的jar包
  // 用于生成classpath（最后要加上游戏本体包，就是该文件中的jar）
  late List<Library> libraries;

  // 客户端、服务端及其mapping文件下载地址
  late Map<String, Artifact> downloads;

  // late dynamic logging;
  // late String type;
  // late String time;
  // late String releaseTime;
  // late int minimumLauncherVersion;
  // late bool root;

  VersionJson(this.dir, this.name);

  Future<VersionJson> load() async {
    String path = "$dir/$name.json";
    // String path = "$versionDir/$versionName";
    File file = File(path);
    String content = await file.readAsString();
    dynamic map = json.decode(content);
    if (map is JsonMap) {
      parse(map);
    }
    return this;
  }

  void parse(Map<String, dynamic> json) {
    id = json["id"] as String;

    dynamic tmp = json["arguments"];
    arguments = <Argument>[];
    jvmArguments = <Argument>[];

    jar = json["jar"] as String;

    tmp = json["assetIndex"];
    if (tmp is JsonMap) assetIndex = AssetIndex.fromJson(tmp);

    assets = json["assets"] as String;

    tmp = json["javaVersion"];
    if (tmp is JsonMap) javaVersion = tmp;

    tmp = json["libraries"];
    if (tmp is List) {
      libraries = <Library>[];
      for (var libJson in tmp) {
        if (libJson is JsonMap) {
          Library library = Library.fromJson(libJson);
          libraries.add(library);
        }
      }
    }

    tmp = json["downloads"];
    if (tmp is JsonMap) {
      downloads = <String, Artifact>{};
      for (var entry in tmp.entries) {
        String file = entry.key;
        if (entry.value is JsonMap) {
          Artifact artifact = Artifact.fromJson(entry.value);
          downloads[file] = artifact;
        }
      }
    }
  }
}
