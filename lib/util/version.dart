import 'package:sprintf/sprintf.dart';

class Version implements Comparable<Version> {
  static RegExp regex = RegExp(
      r"^(0|[1-9]\d*)(\.(0|[1-9]\d*))?(\.(0|[1-9]\d*))?(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$");

  int? major;
  int? minor;
  int? patch;
  String? preRelease;
  String? build;

  String? get preReleaseType {
    if (preRelease != null) {
      int idx = preRelease!.indexOf(".");
      if (idx > 0) {
        return preRelease!.substring(0, idx);
      }
      return preRelease;
    }
    return null;
  }

  int? get preReleaseTypeValue {
    if (preReleaseType != null) {
      switch (preReleaseType) {
        case "snapshot":
          return 50;
        case "alpha":
          return 60;
        case "beta":
          return 70;
        case "pre":
          return 80;
        case "rc":
          return 90;
        default:
          return 0;
      }
    }
    return 99;
  }

  int? get preReleaseVersion {
    if (preRelease != null) {
      int idx = preRelease!.indexOf(".");
      if (idx > 0) {
        return int.tryParse(preRelease!.substring(idx + 1));
      }
    }
    return null;
  }

  int? get buildVersion {
    if (build != null) {
      int idx = build!.indexOf(".");
      if (idx > 0) {
        return int.tryParse(build!.substring(idx + 1));
      }
    }
    return null;
  }

  Version(String v) {
    var matcher = regex.firstMatch(v);
    if (matcher != null) {
      major = int.tryParse(matcher[1] ?? "");
      minor = int.tryParse(matcher[3] ?? "");
      patch = int.tryParse(matcher[5] ?? "");
      preRelease = matcher[6];
      build = matcher[7];
    }
  }

  String toPadded() {
    StringBuffer buffer = StringBuffer();
    buffer.write(sprintf("%03i", [major ?? 0]));
    buffer.write(sprintf(".%03i", [minor ?? 0]));
    buffer.write(sprintf(".%03i", [patch ?? 0]));
    buffer.write(sprintf(
        "-%02i.%03i", [preReleaseTypeValue ?? 0, preReleaseVersion ?? 0]));
    buffer.write(sprintf("+build.%05i", [buildVersion ?? 0]));
    return buffer.toString();
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    if (major != null) buffer.write(major);
    if (minor != null) buffer.write(".$minor");
    if (patch != null) buffer.write(".$patch");
    if (preRelease != null) buffer.write("-$preRelease");
    if (build != null) buffer.write("+$build");
    return buffer.toString();
  }

  @override
  int compareTo(Version other) {
    return toPadded().compareTo(other.toPadded());
  }
}
