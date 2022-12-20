import 'package:flutter_test/flutter_test.dart';

import 'package:amcl/main.mapper.g.dart';
import 'package:amcl/main.reflectable.dart';
import 'package:amcl/launcher/version_json.dart';

void main() {
  initializeReflectable();
  initializeJsonMapper();

  test("用例1", () async {
    var versionJson = VersionJson.lazy(
      r"D:\Minecraft\Avalon-2211\.minecraft\versions\1.19.2", 
      "1.19.2",
    );

    var loaded = await versionJson.load();
    expect(loaded, true);
    expect(versionJson.id, "1.19.2");
  });
}