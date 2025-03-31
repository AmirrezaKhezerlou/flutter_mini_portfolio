import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_plus/Controllers/home_controller.dart';
import 'package:portfolio_plus/about/view/about.dart';
import 'package:portfolio_plus/config/appConfig.dart';
import 'package:portfolio_plus/dashboard/view/dashboard.dart';
import 'package:portfolio_plus/home/widgets/footer_widget.dart';
import 'package:portfolio_plus/home/widgets/toolbar_widget.dart';

import '../../projects/projects.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});
  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          const WebToolbar(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller:controller.pageController,
              children: [
                DashboardPage(),
                const AboutMePage(),
                ProjectsPage(),
              ],
            ),
          ),
           WebFooter(owner: AppConfig.userFullName),
        ],
      ),
    );
  }
}
