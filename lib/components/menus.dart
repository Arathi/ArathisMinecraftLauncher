import 'package:flutter/material.dart';

import '../amcl_app.dart';

class ClickableMenuItem extends StatelessWidget {
  Widget? item;
  void Function()? onClick;

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
    return GestureDetector(
      child: item,
      onTap: onClick,
    );
  }
}

abstract class BaseMenu extends StatelessWidget {
  AppState appState;

  BaseMenu(this.appState, {super.key});
}
