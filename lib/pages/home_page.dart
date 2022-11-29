import 'package:flutter/material.dart';

import '../amcl_app.dart';
import '../components/menus.dart';

class HomePage extends StatelessWidget {
  AMCLState state;

  HomePage(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    String userName =
        (state.currentUser != null) ? state.currentUser!.name : "请创建或选择用户";
    return Container(
      child: Row(children: [
        MainMenu(state),
        Center(child: Text("欢迎，$userName")),
      ]),
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/background.jpg"),
        fit: BoxFit.contain,
      )),
    );
  }
}
