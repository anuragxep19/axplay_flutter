import 'package:flutter/material.dart';
import 'package:axplay/controller/video_controller.dart';
import 'package:axplay/utils/responsive.dart';
import 'package:axplay/view/home/home_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VideoController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        ScreenScaler.init(context); //  Init once here globally
        return child!;
      },
      home: HomeView(),
    );
  }
}
