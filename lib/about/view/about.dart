import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_plus/config/appConfig.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 900;

    return Scaffold(
      backgroundColor: Color(int.parse(AppConfig.backgroundColor.replaceFirst('#', '0xff'))),

      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.0 : 32.0,
              vertical: 16.0,
            ),
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                AppConfig.userImage,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 16),
                Text(
                  AppConfig.userAboutText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    AppConfig.userImage,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Icon(
                Icons.person_outline,
                size: 32,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                AppConfig.userAboutText,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}