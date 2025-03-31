import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:portfolio_plus/Controllers/dashboard_controller.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/appConfig.dart';


class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});
  final DashboardController controller = Get.find();

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
                fit: BoxFit.cover
            )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
              vertical: isMobile ? 20 : 30
          ),
          child: isMobile
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildProfileImage(),
        ),
        Expanded(
          flex: 3,
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //FloatingProfileImage(),
          _buildProfileImage(),
          const SizedBox(height: 20),
          _buildGreetingText(),
          const SizedBox(height: 10),
          _buildExpertiseText(),
          const SizedBox(height: 20),
          _buildDescriptionText(),
          const SizedBox(height: 20),
          _buildSocialLinks(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGreetingText(),
        const SizedBox(height: 20),
        _buildExpertiseText(),
        const SizedBox(height: 30),
        _buildDescriptionText(),
        const SizedBox(height: 40),
        _buildSocialLinks(),
        const SizedBox(height: 30),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildGreetingText() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Text(
              "سلام من ${AppConfig.userName} هستم",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
                height: 1.2,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpertiseText() {
    return Directionality(textDirection: TextDirection.rtl,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 26,
          fontFamily: PersianFonts.Vazir.fontFamily,
          fontWeight: FontWeight.w500,
          color: Colors.indigo.shade600,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              AppConfig.userExpert,
              speed: const Duration(milliseconds: 100),
              textAlign: TextAlign.center
            ),
          ],
          isRepeatingAnimation: false,
        ),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
                AppConfig.userMiniDescription,
              style: TextStyle(
                fontSize: 17,
                height: 1.6,
                color: Colors.blueGrey.shade800,
                fontWeight: FontWeight.w400,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      children: [
        _socialIconButton('assets/icons/facebook.svg', Colors.blue.shade800,AppConfig.userFacebook),
        _socialIconButton('assets/icons/instagram.svg', Colors.blue.shade600,AppConfig.userInstagramLink),
        _socialIconButton('assets/icons/telegram.svg', Colors.indigo,AppConfig.userTelegramLink),
        _socialIconButton('assets/icons/linkedin.svg', Colors.indigo,AppConfig.userLinkedinLink),

      ],
    );
  }

  Widget _socialIconButton(String icon, Color color,String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        elevation: 2,
        shadowColor: color.withOpacity(0.3),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () async{
            await launchUrl(Uri.parse(url));
          },
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              icon,
              color: color,
             width: 22,
              height: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildAnimatedButton(
          "دانلود رزومه",
          'assets/icons/download.svg',
          Colors.white,
          Colors.indigo.shade600,
          true,
          AppConfig.userResumeLink,
        ),
        const SizedBox(width: 15),

        _buildAnimatedButton(
          "تماس با من",
          'assets/icons/message.svg',
          Colors.indigo.shade50,
          Colors.indigo.shade800,
          false,
          AppConfig.userContactLink,
        ),
      ],
    );
  }

  Widget _buildAnimatedButton(
      String text,
      String icon,
      Color bgColor,
      Color textColor,
      bool isPrimary,
      String link,
      ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: ElevatedButton.icon(
              onPressed: () {
                launchUrl(Uri.parse(link));
              },
              icon: SvgPicture.asset(
                icon,
                color: isPrimary ? bgColor : textColor,
              ),
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPrimary ? bgColor : textColor,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPrimary ? textColor : bgColor,
                foregroundColor: isPrimary ? bgColor : textColor,
                elevation: 0,
                side: isPrimary
                    ? BorderSide.none
                    : BorderSide(color: textColor.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final safeOpacity = value.clamp(0.0, 1.0);
        return Center(
          child: AnimatedBuilder(
            animation: AnimationController(
              duration: const Duration(milliseconds: 3000),
              vsync: Scaffold.of(context),
            )..repeat(reverse: true),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, sin(DateTime.now().millisecondsSinceEpoch * 0.001) * 5),
                child: Opacity(
                  opacity: safeOpacity, // Use the clamped value
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.7, end: 0.9),
                          duration: const Duration(milliseconds: 2000),
                          curve: Curves.easeInOut,
                          builder: (context, glowValue, _) {
                            return Container(
                              width: 320,
                              height: 320,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.blue.shade200.withOpacity(safeOpacity * 0.6),
                                    Colors.purple.shade200.withOpacity(safeOpacity * 0.3),
                                    Colors.transparent,
                                  ],
                                  radius: glowValue,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          width: 230,
                          height: 230,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                Colors.blue.shade300,
                                Colors.purple.shade300,
                                Colors.pink.shade300,
                                Colors.blue.shade300,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 215,
                          height: 215,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              AppConfig.userImage,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


}