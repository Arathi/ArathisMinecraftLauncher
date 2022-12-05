import 'package:flutter/material.dart';

import '../amcl_app.dart';

abstract class BasePage extends StatefulWidget {
  AppState appState;
  BasePage(this.appState, {super.key});
}

class BasePageState<P extends BasePage> extends State<P> {
  AppState get appState => widget.appState;

  Widget buildMenu(BuildContext context) {
    return SizedBox(
      width: 256,
      child: Container(
        color: const Color(0xCCFFFFFF),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Text("Body");
  }

  Decoration getBackground() {
    const String imagePath = "assets/background.jpg";
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getBackground(),
        child: Row(
          children: [
            buildMenu(context),
            const SizedBox(width: 5),
            buildBody(context),
          ],
        ),
      ),
    );
  }
}
