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
