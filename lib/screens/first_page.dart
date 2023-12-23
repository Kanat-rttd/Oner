import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/auth/login_screen.dart';
import 'package:oner/auth/signup_screen.dart';
import 'package:oner/screens/bottom_navigation/home_screen.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const HomeScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добро пожаловать!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oner',
              style: TextStyle(
                fontSize: 35,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/VanGogh-starry_night.jpg'),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 240, // Установите желаемую ширину кнопок
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Войти',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 240, // Установите желаемую ширину кнопок
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Зарегистрироваться',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text(
                'Свернуть',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
