import 'package:amcl/pages/test_page.dart';

import 'models.dart';
import 'pages/home_page.dart';
import 'pages/accounts_page.dart';
import 'pages/downloads_page.dart';
import 'package:flutter/material.dart';

class AMCLApp extends StatefulWidget {
  const AMCLApp({super.key});

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<AMCLApp> {
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

  late GlobalKey<NavigatorState> _navigator;

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

    _navigator = GlobalKey();

    super.initState();
  }

  Map<String, WidgetBuilder> router(BuildContext context) {
    Map<String, WidgetBuilder> router = <String, WidgetBuilder>{
      "/home": (context) => HomePage(this),
      "/accounts": (context) => AccountsPage(this),
      "/downloads/mods": (context) => DownloadsPage(this, "/downloads/mods"),
      "/test": (context) => TestPage(this),
    };
    return router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Arathis Minecraft Launcher",
      navigatorKey: _navigator,
      routes: router(context),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/downloads/mods",
    );
  }
}
