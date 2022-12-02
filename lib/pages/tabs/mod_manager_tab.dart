import 'package:amcl/clients/curseforge/versions.dart';
import 'package:flutter/material.dart';

import '../../amcl_app.dart';
import '../../clients/curseforge_client.dart';
import '../../clients/curseforge/categories.dart';
import '../../clients/curseforge/mods.dart';

class ModManagerTab extends StatefulWidget {
  AMCLState amclState;

  ModManagerTab(this.amclState, {super.key});

  @override
  State<StatefulWidget> createState() => ModManagerState();
}

class ModManagerState extends State<ModManagerTab> {
  AMCLState get amclState => widget.amclState;
  late CurseForgeClient _cfapi;
  late TextEditingController _keywordsController;

  Map<int, Category> _categories = <int, Category>{};
  Map<int, VersionTypeInfo> _versionTypes = <int, VersionTypeInfo>{};
  Map<String, String> _gameVersions = <String, String>{};
  String _keywords = "";

  static const Map<int, String> _sortFields = <int, String>{
    1: "功能（Featured）",
    2: "流行度（Popularity）",
    3: "最后更新时间（LastUpdated）",
    4: "名称（Name）",
    5: "作者（Author）",
    6: "总下载量（TotalDownloads）",
    7: "分类（Category）",
    8: "游戏版本（GameVersion）",
  };
  static const Map<String, String> _sortOrders = <String, String>{
    "asc": "升序（asc）",
    "desc": "降序（desc）"
  };
  static const Map<int, String> _modLoaders = <int, String>{
    0: "Any",
    1: "Forge",
    2: "Cauldron",
    3: "LiteLoader",
    4: "Fabric",
    5: "Quilt",
  };

  Map<int, MapEntry<int, String>> get _sortFieldItems {
    var items = <int, MapEntry<int, String>>{};
    for (var entry in _sortFields.entries) {
      items[entry.key] = entry;
    }
    return items;
  }

  Map<String, MapEntry<String, String>> get _sortOrderItems {
    var items = <String, MapEntry<String, String>>{};
    for (var entry in _sortOrders.entries) {
      items[entry.key] = entry;
    }
    return items;
  }

  Map<int, MapEntry<int, String>> get _modLoaderItems {
    var items = <int, MapEntry<int, String>>{};
    for (var entry in _modLoaders.entries) {
      items[entry.key] = entry;
    }
    return items;
  }

  int? categoryId;
  int? gameVersionTypeId;
  String? gameVersion;
  int? sortField;
  String? sortOrder;
  int? modLoaderType;

  List<Mod> results = <Mod>[];

  @override
  void initState() {
    _cfapi = CurseForgeClient();

    _cfapi.getCategories(classId: CurseForgeClient.classIdMods).then((value) {
      setState(() {
        _categories = <int, Category>{};
        for (var cat in value) {
          _categories[cat.id] = cat;
        }
        print("【ModManagerState】获取到模组分类${_categories.length}个");
      });
    });

    _cfapi.getVersionTypeInfos().then((value) {
      setState(() {
        _versionTypes = <int, VersionTypeInfo>{};
        for (var vt in value) {
          _versionTypes[vt.id] = vt;
        }
        print("【ModManagerState】获取到版本类型${_versionTypes.length}个");
      });
    });

    _keywordsController = TextEditingController(text: _keywords);

    super.initState();
  }

  void _onBtnSearchClick() {
    // 清空搜索结果
    print("清空搜索结果");
    setState(() => results.clear());

    if (_keywords.isNotEmpty) {
      var keywordList = _keywords.split(",");
      for (var keyword in keywordList) {
        keyword = keyword.trim();
        if (keyword.startsWith("@") && keyword.length > 1) {
          // @slug
          var slug = keyword.substring(1);
          print("搜索特定MOD：@$slug");
          _search(slug: slug);
        } else if (keyword.startsWith("#") && keyword.length > 1) {
          // #modId
          var modId = int.tryParse(keyword);
          if (modId != null) {
            print("搜索特定MOD：#$modId");
            _search(modId: modId);
          }
        } else {
          // searchFilter
          print("根据关键词搜索：$keyword");
          _search(searchFilter: keyword);
        }
      }
    } else {
      _search();
    }
  }

  void _search({String? searchFilter, String? slug, int? modId}) {
    if (modId == null) {
      print("根据条件进行搜索");
      _cfapi
          .searchMods(
        classId: CurseForgeClient.classIdMods,
        categoryId: categoryId,
        gameVersion: gameVersion,
        searchFilter: searchFilter,
        sortField: sortField,
        sortOrder: sortOrder,
        modLoaderType: modLoaderType,
        gameVersionTypeId: gameVersionTypeId,
        slug: slug,
      )
          .then((value) {
        print("获取搜索结果${value.length}个");
        setState(() => results.addAll(value));
      });
    } else {
      print("根据ID获取模组");
      _cfapi.getMod(modId).then((value) {
        setState(() {
          if (value != null) {
            results.add(value);
          } else {
            print("未找到id为$modId的模组");
          }
        });
      });
    }
  }

  void _onCategoryIdChanged(int? catId) {
    Category? cat = catId != null ? _categories[catId] : null;
    if (cat != null) {
      print("分类发生变更：$catId - ${cat.name}");
      setState(() => categoryId = catId);
    } else {
      print("选择了无效的分类ID：$catId");
      categoryId = null;
    }
  }

  void _onGameVersionTypeIdChanged(int? vtId) {
    VersionTypeInfo? vt = vtId != null ? _versionTypes[vtId] : null;
    if (vt != null) {
      print("分类发生变更：$vtId - ${vt.name}");
      setState(() {
        gameVersionTypeId = vtId;
        gameVersion = null;
        _gameVersions.clear();
        for (var v in vt.versions) {
          _gameVersions[v] = v;
        }
      });
    }
  }

  DropdownButton buildDropdownMenu<K, V>(
    Map<K, V> items,
    K? value,
    Function(V) menuItemBuilder,
    Function(K?) onChanged, {
    String? nullValueText = "（请选择）",
  }) {
    var menuItems = <DropdownMenuItem<K>>[];
    if (nullValueText != null) {
      menuItems.add(DropdownMenuItem<K>(
        value: null,
        child: Text(nullValueText),
      ));
    }
    for (var entry in items.entries) {
      menuItems.add(menuItemBuilder(entry.value));
    }

    return DropdownButton<K>(
      items: menuItems,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget buildConditionForm() {
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 关键字
        Row(
          children: [
            const SizedBox(width: 100, child: Text("关键字")),
            // TextField(
            //   controller: _keywordsController,
            // ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _onBtnSearchClick,
            ),
          ],
        ),
        // 分类
        Row(
          children: [
            const SizedBox(width: 100, child: Text("分类")),
            buildDropdownMenu<int, Category>(
              _categories,
              categoryId,
              (cat) {
                return DropdownMenuItem<int>(
                  value: cat.id,
                  child: Text(cat.name),
                );
              },
              _onCategoryIdChanged,
            ),
          ],
        ),
        // 版本
        Row(
          children: [
            const SizedBox(width: 100, child: Text("游戏版本")),
            buildDropdownMenu<int, VersionTypeInfo>(
              _versionTypes,
              gameVersionTypeId,
              (vt) {
                return DropdownMenuItem<int>(
                  value: vt.id,
                  child: Text(vt.name),
                );
              },
              _onGameVersionTypeIdChanged,
            ),
            const SizedBox(width: 16),
            buildDropdownMenu<String, String>(
              _gameVersions,
              gameVersion,
              (gv) => DropdownMenuItem<String>(
                value: gv,
                child: Text(gv),
              ),
              (gv) => setState(() => gameVersion = gv),
            )
          ],
        ),
        // 排序
        Row(
          children: [
            const SizedBox(width: 100, child: Text("排序规则")),
            buildDropdownMenu<int, MapEntry<int, String>>(
              _sortFieldItems,
              sortField,
              (entry) => DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              ),
              (value) => setState(() => sortField = value),
            ),
            const SizedBox(
              width: 16,
            ),
            buildDropdownMenu<String, MapEntry<String, String>>(
              _sortOrderItems,
              sortOrder,
              (entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              ),
              (value) => setState(() => sortOrder = value),
            ),
          ],
        ),
        // 模组加载器
        Row(
          children: [
            const SizedBox(
              width: 100,
              child: Text("模组加载器"),
            ),
            buildDropdownMenu<int, MapEntry<int, String>>(
              _modLoaderItems,
              modLoaderType,
              (entry) => DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              ),
              (value) => setState(() => modLoaderType = value),
            ),
          ],
        ),
      ],
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xCCEEEEEE),
      ),
      child: column,
    );
  }

  Widget buildResult(Mod mod) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 8),
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xCCEEEEEE),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.image,
            size: 32,
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${mod.mainAuthor.name}/${mod.name}"),
              Text("${mod.summary}"),
            ],
          )
        ],
      ),
    );
  }

  Widget buildResults() {
    if (results.isEmpty) {
      return const Center(child: Text("未找到有效数据"));
    }

    List<Widget> resultWidgets = <Widget>[];
    for (Mod mod in results) {
      Widget resultWidget = buildResult(mod);
      resultWidgets.add(resultWidget);
    }
    return ListView(children: resultWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildConditionForm(),
        const SizedBox(height: 10),
        Expanded(
          child: buildResults(),
        ),
      ],
    );
  }
}
