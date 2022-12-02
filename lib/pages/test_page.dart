import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  Widget buildMenu() {
    return SizedBox(
      width: 256,
      child: Container(color: const Color(0x80FFFFFF)),
    );
  }

  Widget ColorBlock(Color color, {double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(color: color),
    );
  }

  Widget buildConditionsForm() {
    // return SizedBox(
    //   height: 256,
    //   width: 100,
    //   child: Container(
    //     color: Colors.white,
    //   ),
    // );

    var flex = Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorBlock(Colors.black, width: 100, height: 100),
        ColorBlock(Colors.white, width: 100, height: 110),
        ColorBlock(Colors.black, width: 100, height: 120),
        ColorBlock(Colors.white, width: 100, height: 130),
        ColorBlock(Colors.black, width: 100, height: 140),
        ColorBlock(Colors.white, width: 100, height: 150),
        ColorBlock(Colors.black, width: 100, height: 160),
        ColorBlock(Colors.white, width: 100, height: 170),
        ColorBlock(Colors.black, width: 100, height: 180),
      ],
    );

    return Container(
      // padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      margin: EdgeInsets.only(top: 10, right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          ColorBlock(Colors.black, width: 100, height: 100),
        ],
      ),
    );
  }

  Widget buildResults() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Container(
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          buildMenu(),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: [
                buildConditionsForm(),
                const SizedBox(height: 10),
                buildResults()
              ],
            ),
          ),
          // Column(
          //   children: [
          //     //
          //     Expanded(
          //       child: buildConditionsForm(),
          //     ),
          //     const SizedBox(height: 10),
          //     buildResults()
          //   ],
          // ),
        ],
      ),
    );
  }
}
