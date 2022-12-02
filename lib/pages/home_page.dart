import 'package:flutter/material.dart';

import '../amcl_app.dart';
import '../components/menus.dart';

class MainMenu extends BaseMenu {
  MainMenu(AMCLState state, {Key? key}) : super(state, key: key);

  Widget buildCurrentUser(LauncherUser? user) {
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
    );
  }

  Widget buildCurrentGame(Game? game) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      color: const Color(0x80FFFFFF),
      padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("账户"),
        const Divider(),
        buildCurrentUser(state.currentUser),
        const SizedBox(height: 32),
        // -----
        const Text("游戏"),
        const Divider(),
        buildCurrentGame(state.currentGame),
        ClickableMenuItem.icon(
          Icons.menu,
          "版本列表",
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Icons.download,
          "下载",
          iconSize: 24,
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

class HomePage extends StatelessWidget {
  AMCLState state;

  HomePage(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    String userName =
        (state.currentUser != null) ? state.currentUser!.name : "请创建或选择用户";
    return Row(children: [
      MainMenu(state),
      const SizedBox(width: 10),
      Center(child: Text("欢迎，$userName")),
    ]);
  }
}
