import 'package:flutter/material.dart';

import '../amcl_app.dart';

class ClickableMenuItem extends StatelessWidget {
  Widget? item;
  Function? onClick;

  ClickableMenuItem(this.item, {this.onClick, super.key});

  ClickableMenuItem.icon(dynamic image, String text,
      {double iconSize = 32,
      double height = 40,
      String? description,
      this.onClick,
      super.key}) {
    List<Widget> texts = <Widget>[];
    texts.add(Text(text));
    if (description != null) {
      texts.add(Text(
        description,
        style: const TextStyle(
            color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
      ));
    }

    Widget? icon;

    if (image is IconData) {
      icon = SizedBox(
          width: height,
          height: height,
          child: Center(
              child: Icon(
            image,
            size: iconSize,
          )));
    } else {
      icon = SizedBox(
        height: height,
        child: Center(
          child: Container(
            width: iconSize,
            height: iconSize,
            color: Colors.black,
          ),
        ),
      );
    }

    item = Container(
        height: iconSize * 1.2,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          icon,
          const SizedBox(width: 10),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: texts)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: item);
  }
}

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

abstract class BaseMenu extends StatelessWidget {
  AMCLState state;

  BaseMenu(this.state, {super.key});
}
