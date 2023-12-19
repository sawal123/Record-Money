import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record_mobile/config/app_color.dart';
import 'package:money_record_mobile/config/session.dart';
import 'package:money_record_mobile/data/model/user.dart';
import 'package:money_record_mobile/presentation/page/auth/login_page.dart';
import 'package:money_record_mobile/presentation/page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: AppColor.primary,
        colorScheme: ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: AppColor.primary, foregroundColor: Colors.white),
      ),
      home: FutureBuilder(
        future: Session.getUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.data != null && snapshot.data!.idUser != null) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}