import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:community_material_icon/community_material_icon.dart';

import '../components/menus.dart';
import 'base_page.dart';
import 'tabs/mod_manager_tab.dart';

class DownloadsPageMenu extends BaseMenu {
  DownloadsPageMenu(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      color: const Color(0x80FFFFFF),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const Text("下载"),
          ],
        ),
        const SizedBox(height: 32),
        // -----
        const Text("新游戏"),
        const Divider(),
        ClickableMenuItem.icon(
          CupertinoIcons.gamecontroller_fill,
          "游戏",
          iconSize: 24,
          onClick: () => Navigator.pushNamed(context, "/downloads/games"),
        ),
        ClickableMenuItem.icon(
          CupertinoIcons.cube_box_fill,
          "整合包",
          iconSize: 24,
          onClick: () => Navigator.pushNamed(context, "/downloads/modPacks"),
        ),
        const SizedBox(height: 32),
        // -----
        const Text("游戏内容"),
        const Divider(),
        ClickableMenuItem.icon(
          Icons.extension,
          "模组",
          iconSize: 24,
          onClick: () => Navigator.pushNamed(context, "/downloads/mods"),
        ),
        ClickableMenuItem.icon(
          Ionicons.folder,
          "资源包",
          onClick: () =>
              Navigator.pushNamed(context, "/downloads/resourcePacks"),
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Ionicons.earth_sharp,
          "世界",
          onClick: () => Navigator.pushNamed(context, "/downloads/worlds"),
          iconSize: 24,
        ),
        const SizedBox(height: 32),
        // -----
        const Text("运行环境"),
        const Divider(),
        ClickableMenuItem.icon(
          // CommunityMaterialIcons.language_java,
          const FaIcon(FontAwesomeIcons.java).icon,
          "JDK",
          iconSize: 24,
          onClick: () => Navigator.pushNamed(context, "/downloads/jdks"),
        ),
      ]),
    );
  }
}

class DownloadsPage extends BasePage {
  String route;

  DownloadsPage(super.appState, this.route, {super.key});

  @override
  State<StatefulWidget> createState() => DownloadsPageState();
}

class DownloadsPageState extends BasePageState<DownloadsPage> {
  Widget buildTab() {
    switch (widget.route) {
      case "/downloads/mods":
        return ModManagerTab(appState);
    }
    return const Text("下载");
  }

  @override
  Widget buildMenu(BuildContext context) {
    return DownloadsPageMenu(appState);
  }

  @override
  Widget buildBody(BuildContext context) {
    return Expanded(child: buildTab());
  }
}
