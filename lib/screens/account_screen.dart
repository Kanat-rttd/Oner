import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/screens/home_screen.dart';
import 'package:oner/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Закрываем диалог
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text('Да'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), // Закрываем диалог
            child: const Text('Нет'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Username'),
        actions: [
          IconButton(
            onPressed: () {
              // Действие по нажатию на кнопку "Редактировать профиль"
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              // Действие по нажатию на кнопку "Поделиться профилем"
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    // Здесь нужно подставить ссылку на аватар пользователя
                    backgroundImage: NetworkImage(
                      'https://example.com/avatar.jpg',
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '123', // Количество постов
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Text('Посты'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Имя пользователя', // Имя пользователя
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Био пользователя', // Био пользователя
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _showLogoutDialog(context),
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
