import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/screens/bottom_navigation/account_screen_components/profile_menu.dart';
import 'package:oner/screens/bottom_navigation/account_screen_components/profile_pic.dart';

class Body extends StatelessWidget {
  final String? firstName;

  const Body({Key? key, this.firstName}) : super(key: key);

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text('Да'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Нет'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const ProfilePic(),
          const SizedBox(height: 20),

          ProfileMenu(
            icon: "assets/user.svg",
            text: "Мой Аккаунт",
            press: () {
              Navigator.pushNamed(context, '/editProfile');
            },
          ),
          ProfileMenu(
            icon: "assets/loved-post.svg",
            text: "Мои посты",
            press: () {},
          ),
          ProfileMenu(
            icon: "assets/settings.svg",
            text: "Настройки",
            press: () {},
          ),
          ProfileMenu(
            icon: "assets/help.svg",
            text: "Помощь",
            press: () {},
          ),
          ProfileMenu(
            icon: "assets/logout.svg",
            text: "Выйти",
            press: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
