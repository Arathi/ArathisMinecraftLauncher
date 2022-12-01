import 'package:flutter/material.dart';

import '../../amcl_app.dart';

class ModManagerTab extends StatefulWidget {
  AMCLState amclState;

  ModManagerTab(this.amclState, {super.key});

  @override
  State<StatefulWidget> createState() => ModManagerState();
}

class ModManagerState extends State<ModManagerTab> {
  AMCLState get amclState => widget.amclState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Mod管理");
  }
}
