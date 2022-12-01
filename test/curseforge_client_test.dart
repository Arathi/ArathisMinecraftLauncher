import 'package:amcl/clients/curseforge_client.dart';

import 'package:amcl/clients/curseforge/messages.dart';

void main() async {
  var client = CurseForgeClient(apiKey: r"");
  await testGetVersionTypes(client);
}

Future testGetVersions(CurseForgeClient client) async {
  List<Versions> versionsList = await client.getVersions();
  for (var vs in versionsList) {
    print("读取版本类型：${vs.type}，版本数量：${vs.versions.length}");
  }
}

Future testGetVersionTypes(CurseForgeClient client) async {
  List<VersionType> types = await client.getVersionTypes();
  for (var vt in types) {
    print("读取版本类型：${vt.id}，版本类型名称：${vt.name}");
  }
}
