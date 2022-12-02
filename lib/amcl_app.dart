import 'package:amcl/pages/test_page.dart';

import 'pages/home_page.dart';
import 'pages/accounts_page.dart';
import 'pages/download_page.dart';
import 'package:flutter/material.dart';

class AMCLApp extends StatefulWidget {
  const AMCLApp({super.key});

  @override
  State<StatefulWidget> createState() => AMCLState();
}

enum AMCLPage {
  home,
  accounts,
  games,
  downloads,
  settings,
  test,
}

class AMCLState extends State<AMCLApp> {
  AMCLPage page = AMCLPage.downloads;

  Map<String, LauncherUser> users = <String, LauncherUser>{};
  String? currentUUID;

  Map<String, Game> games = <String, Game>{};
  String? currentGameName;

  LauncherUser? get currentUser {
    if (users.isNotEmpty && currentUUID != null) {
      return users[currentUUID];
    }
    return null;
  }

  Game? get currentGame {
    if (games.isNotEmpty && currentGameName != null) {
      return games[currentGameName];
    }
    return null;
  }

  @override
  void initState() {
    // TODO 从本地文件中加载用户信息
    LauncherUser user = LauncherUser(
      "08f06aad8017326b9f1508496b3630d0",
      "Arathi",
      "",
      type: LauncherUserType.offline,
    );
    users[user.uuid] = user;
    currentUUID = user.uuid;

    // TODO 从配置文件中加载游戏信息
    Game game = Game("1.19.2(Forge)", null);
    games[game.name] = game;
    currentGameName = game.name;
  }

  void setPage(AMCLPage page) {
    setState(() => this.page = page);
  }

  Widget? buildPage() {
    if (page == AMCLPage.home) return HomePage(this);
    if (page == AMCLPage.accounts) return AccountsPage(this);
    if (page == AMCLPage.downloads) return DownloadPage(this);
    if (page == AMCLPage.test) return const TestPage();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Arathis Minecraft Launcher",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // backgroundColor: Colors.amber
      ),
      home: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
        )),
        child: buildPage(),
      )),
    );
  }
}

enum LauncherUserType {
  // 离线用户
  offline,

  // 在线用户
  online,

  // 第三方平台用户
  thirdParty
}

class LauncherUser {
  String uuid;
  String name;
  String icon;
  LauncherUserType type;

  LauncherUser(this.uuid, this.name, this.icon,
      {this.type = LauncherUserType.offline});
}

class Game {
  String name;
  dynamic icon;

  Game(this.name, this.icon);
}
