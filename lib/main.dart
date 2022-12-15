import 'package:flutter/material.dart';

import 'amcl_app.dart';
import 'main.mapper.g.dart';
import 'main.reflectable.dart';

void main() {
  initializeReflectable();
  initializeJsonMapper();
  runApp(const AMCLApp());
}
