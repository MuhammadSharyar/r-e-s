import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScaffold, tabletScaffold, desktopScaffold;
  const ResponsiveLayout({
    Key? key,
    required this.mobileScaffold,
    required this.tabletScaffold,
    required this.desktopScaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 1100) {
        return mobileScaffold;
      }
      // else if (constraints.maxWidth < 1100) {
      //   return tabletScaffold;
      // }
      else {
        return desktopScaffold;
      }
    });
  }
}
