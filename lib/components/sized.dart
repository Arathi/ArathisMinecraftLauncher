import 'package:flutter/cupertino.dart';

class SizedText extends StatelessWidget {
  String text;
  double? width;
  double? height;

  SizedText(this.text, {this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(text),
    );
  }
}
