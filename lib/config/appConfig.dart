import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  static String footerColor = '#ffffff';
  static String toolbarColor = '#ffffff';
  static String backgroundColor = "#ffffff";
  static String websiteTitle = "My website";
  static String userName = "UserName";
  static String userFullName = 'user_fullName';
  static String userExpert = "user_expert";
  static String userMiniDescription = 'user_mini_description';
  static String userImage = 'user_image_url';
  static String userFacebook = 'example';
  static String userTelegramLink = '';
  static String userLinkedinLink = '';
  static String userResumeLink = '';
  static String userContactLink = '';
  static String userInstagramLink = '';
  static String userGithubLink = '';
  static String userAboutText = '';
  static String userGithubUsername = '';

  static Future<void> loadConfig() async {
    final String jsonString = await rootBundle.loadString('assets/config.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    footerColor = (data['footerColor'] ?? footerColor);
    backgroundColor = data['backgroundColor'] ?? backgroundColor;
    toolbarColor = data['toolbarColor'] ?? toolbarColor;
    websiteTitle = (data['website_title'] ?? websiteTitle);
    userName = (data['user_name'] ?? userName);
    userFullName = (data['user_fullName'] ?? userFullName);
    userExpert = (data['user_expert'] ?? userExpert);
    userMiniDescription =
        (data['user_mini_description'] ?? userMiniDescription);
    userImage = (data['user_image_url'] ?? userImage);
    userFacebook = (data['user_facebook_url'] ?? userFacebook);
    userTelegramLink = (data['user_telegram_url'] ?? userTelegramLink);
    userLinkedinLink = (data['user_linkedin_url'] ?? userLinkedinLink);
    userResumeLink = (data['user_resume_url'] ?? userResumeLink);
    userContactLink = (data['user_contact_url'] ?? userContactLink);
    userGithubLink = (data['user_github_url'] ?? userGithubLink);
    userInstagramLink = (data['user_instagram_url'] ?? userInstagramLink);
    userAboutText = (data['user_about_text'] ?? userAboutText);
    userGithubUsername = (data['user_github_username'] ?? userGithubUsername);
  }
}
