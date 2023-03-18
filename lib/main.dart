import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:r_e_s/responsive/desktop_scaffold.dart';
import 'package:r_e_s/responsive/mobile_scaffold.dart';
import 'package:r_e_s/responsive/responsive_layout.dart';
import 'package:r_e_s/responsive/tablet_scaffold.dart';
import 'package:r_e_s/screens/mobile/all_screens/school_screens.dart';
import 'package:r_e_s/screens/mobile/home/school_home.dart';
import 'package:r_e_s/screens/mobile/home/student_home.dart';
import 'package:r_e_s/screens/mobile/home/teacher_home.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: DesktopScaffold(),
      ),
    );
  }
}
//abba@gmail.com 12345678
