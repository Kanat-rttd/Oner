import 'package:flutter/material.dart';
// import 'package:oner/message_screen.dart';
// import 'package:oner/screens/home_screen.dart';
// import 'package:oner/screens/profile/account_screen.dart';

class MainPage extends StatelessWidget{
  const MainPage({super.key});

@override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
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
}