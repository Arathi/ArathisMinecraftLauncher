import 'package:flutter_test/flutter_test.dart';
import 'package:amcl/clients/curseforge_client.dart';
import 'package:amcl/clients/curseforge_models.dart';
import 'package:logger/logger.dart';

import 'package:amcl/main.mapper.g.dart';
import 'package:amcl/main.reflectable.dart';

void main() {
  initializeReflectable();
  initializeJsonMapper();

  var logger = Logger();
  var client = CurseForgeClient();

  test('用例-1-1-获取游戏版本 getVersions', () async {
    var versions = await client.getVersions();
    logger.i("获取游戏版本${versions.length}个");
  });

  test('用例-1-2-获取版本类型 getVersionTypes', () async {
    var types = await client.getVersionTypes();
    logger.i("获取版本类型${types.length}个");
  });

  test('用例-1-3-获取版本分类信息 getVersionTypeInfos', () async {
    var infos = await client.getVersionTypeInfos();
    logger.i("获取分类信息${infos.length}个");
  });

  test('用例-2-1-获取分类 getCategories', () async {
    var cats = await client.getCategories(classId: null);
    logger.i("获取分类${cats.length}个");

    var modCats = await client.getCategories(
      classId: CurseForgeClient.classIdMods,
    );
    logger.i("获取分类${modCats.length}个");
  });

  test('用例-3-1-搜索模组 searchMods', () async {
    logger.i("查询所有MOD");
    var results = await client.searchMods();
    logger.i("获得mod共${results.total}个，当前分页${results.count}个");

    logger.i("查询1.19.2的Forge Mod");
    results = await client.searchMods(
      classId: CurseForgeClient.classIdMods,
      gameVersion: "1.19.2",
      modLoaderType: ModLoaderType.Forge,
      sortField: ModsSearchSortField.Popularity,
      sortOrder: ModsSearchSortOrder.desc,
    );
    logger.i("获得mod共${results.total}个，当前分页${results.count}个");
  });

  test('用例-3-1-1-根据slug搜索模组 searchMods(slug: "jei")', () async {
    logger.i("查询jei");
    var results = await client.searchMods(slug: "jei");
    logger.i("获得mod共${results.total}个，当前分页${results.count}个");
  });

  test('用例-3-2-根据ID获取模组 getMod', () async {
    logger.i("查询245755/Waystones");
    var waystones = await client.getMod(245755);
    logger.i("获取MOD：${waystones.toString()}");
  });

  test('用例-3-3-根据多个ID获取模组列表 getMods', () {});

  test('用例-4-1-获取ID根据模组文件 getModFile', () {});

  test('用例-4-2-根据模组ID获取模组文件列表 getModFiles', () {});

  test('用例-4-3-根据多个模组文件ID获取模组文件列表 getFiles', () {});
}
