import 'package:amcl/amcl_app.dart';
import 'package:amcl/components/menus.dart';
import 'package:flutter/material.dart';

class CreateAccountMenu extends BaseMenu {
  CreateAccountMenu(super.state, {super.key});

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
            Text("账户"),
          ],
        ),
        const SizedBox(height: 32),
        const Text("添加账户"),
        const Divider(),
        ClickableMenuItem.icon(
          Icons.account_box,
          "离线模式",
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Icons.mail,
          "Mojang账户",
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Icons.window,
          "微软账户",
          iconSize: 24,
        ),
        ClickableMenuItem.icon(
          Icons.online_prediction,
          "Little Skin",
          iconSize: 24,
        ),
      ]),
    );
  }
}

class AccountsPage extends StatefulWidget {
  AMCLState state;

  AccountsPage(this.state, {super.key});

  @override
  State<StatefulWidget> createState() => AccountsPageState();
}

class AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CreateAccountMenu(widget.state),
        const SizedBox(width: 10),
      ],
    );
  }
}
