import 'package:flutter/material.dart';

import '../components/menus.dart';
import '../amcl_app.dart';
import 'tabs/mod_manager_tab.dart';

class DownloadPageMenu extends BaseMenu {
  DownloadPageMenu(super.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      color: const Color(0x80FFFFFF),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            IconButton(
              onPressed: () => state.setPage(AMCLPage.home),
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
          Icons.games,
          "游戏",
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Icons.add_box,
          "整合包",
          iconSize: 24,
        ),
        const SizedBox(height: 32),
        // -----
        const Text("游戏内容"),
        const Divider(),
        ClickableMenuItem.icon(
          Icons.view_module,
          "模组",
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Icons.source,
          "资源包",
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Icons.star,
          "世界",
          iconSize: 24,
        ),
        const SizedBox(height: 32),
        // -----
        const Text("运行环境"),
        const Divider(),
        ClickableMenuItem.icon(
          Icons.event_note,
          "JDK",
          iconSize: 24,
        ),
      ]),
    );
  }
}

enum DownloadTab {
  games,
  modPacks,
  modManager,
  resourcePacks,
  worlds,
}

class DownloadPage extends StatefulWidget {
  AMCLState state;

  DownloadPage(this.state, {super.key});

  @override
  State<StatefulWidget> createState() => DownloadPageState();
}

class DownloadPageState extends State<DownloadPage> {
  DownloadTab _tab = DownloadTab.modManager;

  void switchTab(DownloadTab tab) => setState(() => _tab = tab);

  Widget buildTab() {
    if (_tab == DownloadTab.modManager) {
      return ModManagerTab(widget.state);
    }
    return const Text("下载");
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      DownloadPageMenu(widget.state),
      const SizedBox(width: 10),
      Expanded(
        child: buildTab(),
      ),
    ]);
  }
}
