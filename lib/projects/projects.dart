import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Controllers/github_controller.dart';
import 'dart:ui';

class ProjectsPage extends StatelessWidget {
  final GitHubController controller = Get.put(GitHubController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    String _formatNumber(int number) {
      if (number >= 1000) {
        return '${(number / 1000).toStringAsFixed(1)}K';
      }
      return number.toString();
    }

    IconData _getLanguageIcon(String language) {
      switch (language.toLowerCase()) {
        case 'dart':
          return Icons.flutter_dash;
        case 'javascript':
        case 'typescript':
          return Icons.javascript;
        case 'python':
          return Icons.code;
        case 'java':
          return Icons.coffee;
        case 'kotlin':
          return Icons.android;
        case 'swift':
          return Icons.apple;
        default:
          return Icons.code;
      }
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          "پروژه‌های گیت‌هاب",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchRepositories(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 10),
            Text(
              "مخزن‌های من",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          "در حال دریافت پروژه‌ها...",
                          style: TextStyle(),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  );
                }

                if (controller.repositories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.source_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "هیچ پروژه‌ای یافت نشد",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("تلاش مجدد"),
                          onPressed: () => controller.fetchRepositories(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 1;
                    if (constraints.maxWidth > 1200) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth > 900) {
                      crossAxisCount = 3;
                    } else if (constraints.maxWidth > 600) {
                      crossAxisCount = 2;
                    }

                    return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: constraints.maxWidth > 600 ? 1.5 : 1.3,
                      ),
                      itemCount: controller.repositories.length,
                      itemBuilder: (context, index) {
                        var repo = controller.repositories[index];
                        final language = repo['language'] ?? "نامشخص";
                        final stars = repo['stargazers_count'] ?? 0;
                        final forks = repo['forks_count'] ?? 0;

                        Color languageColor = _getLanguageColor(language);

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: languageColor.withOpacity(0.1),
                                offset: const Offset(0, 8),
                                blurRadius: 24,
                                spreadRadius: -4,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: languageColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            color: cardColor,
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {

                                HapticFeedback.lightImpact();
                                Get.bottomSheet(
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 12,
                                            offset: const Offset(0, -2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end, // راست چین
                                        children: [
                                          // نشانگر کشیدن باتم شیت
                                          Center(
                                            child: Container(
                                              width: 40,
                                              height: 4,
                                              margin: const EdgeInsets.only(bottom: 16),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          // عنوان پروژه
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              repo['name'],
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              repo['description'] ?? "بدون توضیحات",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 20),
                                            child: Divider(thickness: 1.2),
                                          ),

                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: _buildInfoRowModern(Icons.code_rounded, "زبان: $language", languageColor),
                                          ),
                                          const SizedBox(height: 12),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: _buildInfoRowModern(Icons.star_rounded, "ستاره‌ها: $stars", Colors.amber[700]!),
                                          ),
                                          const SizedBox(height: 12),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: _buildInfoRowModern(Icons.fork_right_rounded, "انشعاب‌ها: $forks", Colors.blue[700]!),
                                          ),
                                          const SizedBox(height: 28),

                                          SizedBox(
                                            width: double.infinity,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  elevation: 0,
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  foregroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                  launchUrl(Uri.parse(repo['html_url']));
                                                },
                                                icon: const Icon(Icons.open_in_new_rounded, size: 20),
                                                label: const Text(
                                                  "مشاهده در گیت‌هاب",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  enableDrag: true,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Hero(
                                          tag: 'repo_icon_${repo['id']}',
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: languageColor.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: languageColor.withOpacity(0.15),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              _getLanguageIcon(language),
                                              color: languageColor,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Hero(
                                            tag: 'repo_name_${repo['id']}',
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                repo['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  height: 1.3,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                textDirection: TextDirection.rtl,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: Text(
                                        repo['description'] ?? "بدون توضیحات",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: languageColor,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: languageColor.withOpacity(0.4),
                                                    blurRadius: 4,
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              language,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            _buildStatItem(
                                              icon: Icons.star_rounded,
                                              value: _formatNumber(stars),
                                              color: Colors.amber[700]!,
                                            ),
                                            const SizedBox(width: 16),
                                            _buildStatItem(
                                              icon: Icons.fork_right_rounded,
                                              value: _formatNumber(forks),
                                              color: Colors.blue[700]!,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _buildStatItem({required IconData icon, required String value, required Color color}) {
  return Row(
    textDirection: TextDirection.rtl,
    children: [
      Icon(
        icon,
        size: 18,
        color: color,
      ),
      const SizedBox(width: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
    ],
  );
}
Widget _buildInfoRowModern(IconData icon, String text, Color color) {
  return Row(
    children: [
      Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: color,
        ),
      ),
    ],
  );
}
Color _getLanguageColor(String language) {
  switch (language.toLowerCase()) {
    case 'dart':
      return Colors.blue;
    case 'javascript':
      return Colors.yellow[700]!;
    case 'typescript':
      return Colors.blue[300]!;
    case 'python':
      return Colors.green[600]!;
    case 'java':
      return Colors.orange[800]!;
    case 'kotlin':
      return Colors.purple[400]!;
    case 'swift':
      return Colors.orange[400]!;
    case 'c#':
    case 'c-sharp':
      return Colors.green[400]!;
    case 'c++':
      return Colors.red[400]!;
    case 'php':
      return Colors.indigo[400]!;
    case 'go':
      return Colors.blue[200]!;
    case 'ruby':
      return Colors.red[700]!;
    case 'html':
      return Colors.orange[500]!;
    case 'css':
      return Colors.blue[500]!;
    default:
      return Colors.grey;
  }
}