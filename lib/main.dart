import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:portfolio_plus/Controllers/dashboard_controller.dart';
import 'package:portfolio_plus/Controllers/home_controller.dart';
import 'package:portfolio_plus/home/view/home.dart';

import 'config/appConfig.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.loadConfig();
  HomeController homeController = Get.put(HomeController());
  DashboardController dashboardController = Get.put(DashboardController());
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Personal Website',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: PersianFonts.vazirTextTheme,
      ),
      home:  HomePage(),
    );
  }
}

