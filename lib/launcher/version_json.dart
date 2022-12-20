import 'dart:io';

import 'package:dart_json_mapper/dart_json_mapper.dart';

typedef StringKeyMap = Map<String,dynamic>;

@jsonSerializable
class Os {
  String name;
  String? version;
  String? arch;

  Os(this.name, this.version, this.arch);

  @override
  String toString() {
    var info = StringBuffer();
    info.write(name);
    if (version!=null) {
      info.write("($version)");
    }
    return info.toString();
  }
}

@jsonSerializable
class Rule {
  String action;
  dynamic features;
  Os? os;

  Rule(this.action, this.features, this.os);

  @override
  String toString() {
    var info = StringBuffer();
    info.write(action);
    if (features != null && features is StringKeyMap) {
      var map = features as StringKeyMap;
      for (var entry in map.entries) {
        info.write(" ${entry.key}=${entry.value}");
      }
    }
    if (os != null) {
      info.write(" os=$os");
    }
    return info.toString();
  }
}

@jsonSerializable
class Argument {
  List<Rule> rules;

  @JsonProperty(name: "value")
  List<String> values;

  @JsonProperty(ignore: true)
  bool get noRules => rules.isEmpty;

  @JsonProperty(ignore: true)
  String get firstValue => values.first;

  Argument(this.rules, this.values);

  Argument.string(String argument) : rules = [], values = [] {
    values.add(argument);
  }

  @override
  String toString() {
    if (noRules) {
      if (values.length == 1) {
        return firstValue;
      }
      if (values.length > 1) {
        return "[${values.join(",")}]";
      }
      return "[]";
    }
    else if (rules.length == 1) {
      return "<${rules[0]}>[${values.join(",")}]";
    }
    return "<${rules.length}.Rules>[${values.join(",")}]";
  }
}

@jsonSerializable
class JavaVersion {
  String component;
  int majorVersion;

  JavaVersion(this.component, this.majorVersion);
}

@jsonSerializable
class AssetIndex {
  String id;
  String url;
  String sha1;
  int size;
  int totalSize;

  AssetIndex(this.id, this.url, this.sha1, this.size, this.totalSize);
}

@jsonSerializable
class Artifact {
  String? path;
  String url;
  String sha1;
  int size;

  Artifact(this.path, this.url, this.sha1, this.size);
}

@jsonSerializable
class LibraryDownloads {
  Artifact artifact;

  LibraryDownloads(this.artifact);
}

@jsonSerializable
class Library {
  String name;
  LibraryDownloads? downloads;
  List<Rule>? rules;

  Artifact? get artifact => downloads?.artifact;

  Library(this.name, this.downloads, this.rules);
}

@jsonSerializable
class MinecraftDownloads {
  @JsonProperty(name: "client_mappings")
  Artifact? clientMappings;

  Artifact? server;

  Artifact? client;

  @JsonProperty(name: "server_mappings")
  Artifact? serverMappings;

  MinecraftDownloads(
    this.clientMappings,
    this.server,
    this.client,
    this.serverMappings,
  );
}

@jsonSerializable
class VersionJson {
  String? dir;

  String? name;

  late String id;

  late dynamic arguments;

  // 用于生成arguments
  late List<Argument> gameArguments;

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
  late JavaVersion javaVersion;

  // 用于下载依赖的jar包
  // 用于生成classpath（最后要加上游戏本体包，就是该文件中的jar）
  late List<Library> libraries;

  // 客户端、服务端及其mapping文件下载地址
  late MinecraftDownloads downloads;

  // late dynamic logging;
  // late String type;
  // late String time;
  // late String releaseTime;
  // late int minimumLauncherVersion;
  // late bool root;

  VersionJson(
    this.id,
    this.arguments,
    this.jar,
    this.assetIndex,
    this.assets,
    this.javaVersion,
    this.libraries,
    this.downloads,
  ) {
    parseArguments();
  }

  List<Argument> parseArgumentList(List<dynamic> list) {
    List<Argument> args = <Argument>[];
    for (var e in list) {
      if (e is String) {
        args.add(Argument.string(e));
      }
      else if (e is StringKeyMap) {
        var arg = JsonMapper.deserialize<Argument>(e);
        if (arg != null) {
          args.add(arg);
        }
      }
    }
    return args;
  }

  void parseArguments() {
    if (arguments is StringKeyMap) {
      var game = arguments["game"];
      if (game is List) {
        gameArguments = parseArgumentList(game);
      }

      var jvm = arguments["jvm"];
      if (jvm is List) {
        jvmArguments = parseArgumentList(jvm);
      }
    }
  }

  VersionJson.lazy(this.dir, this.name);

  Future<bool> load() async {
    String path = "$dir/$name.json";
    File file = File(path);
    String content = await file.readAsString();
    VersionJson? ver = JsonMapper.deserialize<VersionJson>(content);
    if (ver == null) {
      return false;
    }

    id = ver.id;
    // arguments = ver.arguments;
    gameArguments = ver.gameArguments;
    jvmArguments = ver.jvmArguments;
    jar = ver.jar;
    assetIndex = ver.assetIndex;
    assets = ver.assets;
    javaVersion = ver.javaVersion;
    libraries = ver.libraries;
    downloads = ver.downloads;
    return true;
  }
}
