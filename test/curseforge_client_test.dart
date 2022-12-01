import 'package:amcl/clients/curseforge_client.dart';

import 'package:amcl/clients/curseforge/versions.dart';

void main() async {
  var client = CurseForgeClient();
  await testGetModFiles(client);
}

Future testGetVersions(CurseForgeClient client) async {
  var versionsList = await client.getVersions();
  for (var vs in versionsList) {
    print("读取版本类型：${vs.type}，版本数量：${vs.versions.length}");
  }
}

Future testGetVersionTypes(CurseForgeClient client) async {
  var types = await client.getVersionTypes();
  for (var vt in types) {
    print("读取版本类型：${vt.id}，版本类型名称：${vt.name}");
  }
}

Future testGetVersionTypeInfos(CurseForgeClient client) async {
  var infos = await client.getVersionTypeInfos();
  for (var info in infos) {
    print("读取版本类型：${info.id}，版本名称：${info.name}，版本数量：${info.versions.length}");
  }
}

Future testGetCategories(CurseForgeClient client) async {
  var cats = await client.getCategories();
  for (var cat in cats) {
    print("分类信息：$cat");
  }
}

Future testSearchMods(CurseForgeClient client) async {
  var mods = await client.searchMods(slug: "jei");
  for (var mod in mods) {
    print("模组信息：$mod");
  }
}

Future testGetModFiles(CurseForgeClient client) async {
  int modId = 238222; // jei
  var modFiles = await client.getModFiles(modId);
  for (var file in modFiles) {
    print("模组文件信息：$file");
  }
}
