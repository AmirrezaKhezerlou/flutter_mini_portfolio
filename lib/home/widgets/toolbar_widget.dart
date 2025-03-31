import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_plus/config/appConfig.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/home_controller.dart';

class WebToolbar extends StatefulWidget {
  const WebToolbar({super.key});

  @override
  State<WebToolbar> createState() => _WebToolbarState();
}

class _WebToolbarState extends State<WebToolbar> {
  String? _hoveredItem;

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: Color(int.parse(AppConfig.toolbarColor.replaceFirst('#', '0xff'))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile ? _buildMobileToolbar() : _buildDesktopToolbar(),
    );
  }

  Widget _buildDesktopToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo and website name
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.web,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppConfig.websiteTitle,
              style: const TextStyle(
                color: Colors.indigo,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        // Navigation items
        Row(
          children: [
            _buildNavItem("خانه", Icons.home_outlined,0),
            _buildNavItem("پروژه‌ها", Icons.work_outline,2),
            _buildNavItem("درباره من", Icons.person_outline,1),
            const SizedBox(width: 16),
            _buildContactButton(),
          ],
        )
      ],
    );
  }

  Widget _buildMobileToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.web,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppConfig.websiteTitle,
              style: const TextStyle(
                color: Colors.indigo,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.indigo),
          onPressed: () {
            _showMobileMenu();
          },
        )
      ],
    );
  }

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavItem("خانه", Icons.home_outlined,0),
            _buildNavItem("پروژه‌ها", Icons.work_outline,2),
            _buildNavItem("درباره من", Icons.person_outline,1),
            const SizedBox(height: 16),
            _buildContactButton(),
          ],
        );
      },
    );
  }

  Widget _buildNavItem(String title, IconData icon,int index) {
    final isHovered = _hoveredItem == title;
    HomeController homeController = Get.find();
    return GestureDetector(
      onTap: (){
        homeController.pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredItem = title),
          onExit: (_) => setState(() => _hoveredItem = null),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isHovered ? Colors.indigo.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isHovered ? Colors.indigo : Colors.black54,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: isHovered ? Colors.indigo : Colors.black87,
                    fontSize: 15,
                    fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton() {
    return ElevatedButton(
      onPressed: () {
        launchUrl(Uri.parse(AppConfig.userTelegramLink));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: const Text(
        "تماس با من",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}