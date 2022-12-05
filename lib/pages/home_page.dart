import 'package:flutter/material.dart';

import '../models.dart';
import '../amcl_app.dart';
import '../components/menus.dart';
import 'base_page.dart';

class MainMenu extends BaseMenu {
  MainMenu(AppState state, {Key? key}) : super(state, key: key);

  Widget buildCurrentUser(BuildContext context, LauncherUser? user) {
    String userName;
    String? description;
    if (user != null) {
      userName = user.name;
    } else {
      userName = "没有启动器账户";
      description = "点击此处添加账户";
    }
    return ClickableMenuItem.icon(
      Icons.people,
      userName,
      description: description,
      onClick: () {
        print("点击用户菜单项");
        Navigator.pushNamed(context, "/accounts");
      },
    );
  }

  Widget buildCurrentGame(BuildContext context, Game? game) {
    String gameName;
    String? description;
    if (game != null) {
      gameName = game.name;
    } else {
      gameName = "没有游戏版本";
      description = "点击此处安装游戏";
    }
    return ClickableMenuItem.icon(
      Icons.gamepad,
      gameName,
      description: description,
      onClick: () {
        print("点击游戏菜单项");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      color: const Color(0x80FFFFFF),
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("账户"),
        const Divider(),
        buildCurrentUser(context, appState.currentUser),
        const SizedBox(height: 32),
        // -----
        const Text("游戏"),
        const Divider(),
        buildCurrentGame(context, appState.currentGame),
        ClickableMenuItem.icon(
          Icons.menu,
          "版本列表",
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Icons.download,
          "下载",
          iconSize: 24,
          onClick: () => Navigator.pushNamed(context, "/downloads/mods"),
        ),
        const SizedBox(height: 32),
        // -----
        const Text("通用"),
        const Divider(),
        ClickableMenuItem.icon(
          Icons.settings,
          "设置",
          iconSize: 24,
        )
      ]),
    );
  }
}

class HomePage extends BasePage {
  HomePage(super.appState, {super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();

  @override
  Widget build(BuildContext context) {
    String userName = (appState.currentUser != null)
        ? appState.currentUser!.name
        : "请创建或选择用户";
    return Row(children: [
      MainMenu(appState),
      const SizedBox(width: 10),
      Center(child: Text("欢迎，$userName")),
    ]);
  }
}

class HomePageState extends BasePageState<HomePage> {
  @override
  Widget buildMenu(BuildContext context) {
    return MainMenu(appState);
  }

  @override
  Widget buildBody(BuildContext context) {
    String userName = (appState.currentUser != null)
        ? appState.currentUser!.name
        : "请创建或选择用户";
    return Center(child: Text("欢迎，$userName"));
  }
}
