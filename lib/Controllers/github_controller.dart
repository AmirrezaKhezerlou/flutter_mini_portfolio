import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio_plus/config/appConfig.dart';
import 'package:portfolio_plus/config/messaging_system.dart';

class GitHubController extends GetxController {
  var username = AppConfig.userGithubUsername.obs;
  var repositories = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRepositories();
  }

  Future<void> fetchRepositories() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://api.github.com/users/${username.value}/repos'),
      );

      if (response.statusCode == 200) {
        repositories.value = jsonDecode(response.body);
      } else {

        Messaging.showError(
          title: 'خطا',
          message: "خطا در دریافت اطلاعات از گیت‌هاب",
        );
      }
    } catch (e) {

      Messaging.showError(
        title: 'خطا',
        message: "مشکلی پیش آمد: $e",
      );
    } finally {
      isLoading(false);
    }
  }

  void updateUsername(String newUsername) {
    username.value = newUsername;
    fetchRepositories();
  }
}
