import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oner/mypage/edit_profile.dart';
import 'package:oner/screens/bottom_navigation/account_screen.dart';
import 'package:oner/screens/bottom_navigation/home_screen.dart';
import 'package:oner/auth/login_screen.dart';
import 'package:oner/screens/art_category_pages/music.dart';
import 'package:oner/screens/art_category_pages/parties.dart';
import 'package:oner/screens/art_category_pages/paintings.dart';
import 'package:oner/screens/art_category_pages/films.dart';
import 'package:oner/auth/signup_screen.dart';
import 'package:oner/auth/reset_password_screen.dart';
import 'package:oner/auth/verify_email_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:oner/firebase/firebase_streem.dart';

import 'firebase/firebase_options.dart';

// Firebase Авторизация - Сценарии:
//    Войти - Почта / Пароль
//    Личный кабинет
//    Зарегистрироваться - Почта / Пароль два раза
//        Подтвердить почту - Отправить письмо снова / Отменить
//    Сбросить пароль - Почта

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
        '/music': (context) => const MusicPage(),
        '/parties': (context) => const PartiesPage(),
        '/paintings': (context) => const PaintingsPage(),
        '/films': (context) => const FilmsPage(),
        '/editProfile':(context) => const ProfileEditPage(),
      },
      initialRoute: '/',
    );
  }
}
