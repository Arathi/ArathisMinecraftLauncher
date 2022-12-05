import 'package:amcl/util/version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('用例1-简单版本号解析', () {
    Version v_1_2_0 = Version("1.2");
    expect(v_1_2_0.major, 1);
    expect(v_1_2_0.minor, 2);
    expect(v_1_2_0.patch, null);
  });

  test('用例2-复杂版本号解析', () {
    Version v_1_2_3_beta4_build5 = Version("1.2.3-beta.4+build.5");
    expect(v_1_2_3_beta4_build5.major, 1);
    expect(v_1_2_3_beta4_build5.minor, 2);
    expect(v_1_2_3_beta4_build5.patch, 3);
    expect(v_1_2_3_beta4_build5.preReleaseType, "beta");
    expect(v_1_2_3_beta4_build5.preReleaseVersion, 4);
    expect(v_1_2_3_beta4_build5.buildVersion, 5);
    print(v_1_2_3_beta4_build5.toPadded());
  });

  test('用例3-版本号比较', () {
    List<Version> versions = <Version>[
      Version("1.1"),
      Version("1.2.3-beta.4"),
      Version("1.2.3"),
      Version("1.2.3-snapshot"),
      Version("1.2.4"),
      Version("1.2.3-beta.3"),
      Version("1.3"),
      Version("1.2.3-alpha"),
      Version("1.2.5-rc"),
      Version("1.2.5-rc.2"),
      Version("1.2.6"),
    ];
    versions.sort();

    for (var version in versions) {
      print("$version => ${version.toPadded()}");
    }
  });
}
