import 'package:flutter_test/flutter_test.dart';

import 'package:amcl/launcher/launcher.dart';

void main() {
  test("直接启动", () {
    Launcher launcher = Launcher();
    launcher.launch(
      r'C:\Java\graalvm-ce-java17-22.1.0\bin\java.exe',
      r'D:\Games\Minecraft\1.19\.minecraft\versions\1.19.2',
      r'D:\Games\Minecraft\1.19\.minecraft\versions\1.19.2\1.19.2.json',
    );
  });
}
