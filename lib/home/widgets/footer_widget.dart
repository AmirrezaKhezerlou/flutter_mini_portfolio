import 'package:flutter/material.dart';
import 'package:portfolio_plus/config/appConfig.dart';

class WebFooter extends StatelessWidget {
  final String owner;

  const WebFooter({Key? key, required this.owner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Color(int.parse(AppConfig.footerColor.replaceFirst('#', '0xff'))),
      alignment: Alignment.center,
      child: Text(
        'تمامی حقوق این وب‌سایت متعلق به $owner می‌باشد و هرگونه کپی‌برداری غیرمجاز است.',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      ),
    );
  }
}