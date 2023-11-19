import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/screens/account_screen.dart';
import 'package:oner/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: _buildSearchField(),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCenteredRoundedIcons(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Сообщения',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Моя страница',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            if (user == null) {
              _showRegistrationDialog(context);
            } else {
              Navigator.pushReplacementNamed(context, '/account');
            }
          } else {
            // Добавка по ролям на будущее
          }
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '      Поиск по Oner',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.search),
        ],
      ),
    );
  }

  Widget _buildCenteredRoundedIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/music');
              },
              child: _buildRoundedIcon(Icons.music_note, 'Музыка'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/parties');
              },
              child: _buildRoundedIcon(Icons.cake, 'Праздник'),
            ),
          ],
        ),
        const SizedBox(width: 50),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/paintings');
              },
              child: _buildRoundedIcon(Icons.palette, 'Картины'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/films');
              },
              child: _buildRoundedIcon(Icons.movie, 'Кино'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundedIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            size: 40.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(label),
      ],
    );
  }

  Future<void> _showRegistrationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Хотите ли вы зарегистрироваться или войти?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Войти'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Зарегистрироваться'),
            ),
          ],
        );
      },
    );
  }
}
