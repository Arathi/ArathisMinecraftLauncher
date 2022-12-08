import 'package:flutter_test/flutter_test.dart';
import 'package:amcl/version_json.dart';

void main() async {
  test("测试加载版本json", () async {
    VersionJson mc_1_19_2_forge = VersionJson(
      r"D:\Games\Minecraft\1.19\.minecraft\versions\1.19.2",
      "1.19.2",
    );
    // Future<VersionJson> future = mc_1_19_2_forge.load();
    // future.then((vj) {
    //   print("版本加载完成");
    // });
    await mc_1_19_2_forge.load();
    print("版本加载完成");
  });
}
