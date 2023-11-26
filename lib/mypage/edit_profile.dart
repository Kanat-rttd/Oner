import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/mypage/additional/textbox.dart';


class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //all users
  final userCollection = FirebaseFirestore.instance.collection('user_info');

  //edit field
  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Изменить $field',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Введите новое $field',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //cancel button
          TextButton(
            child: const Text(
              'Отменить',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),

        //save button
        TextButton(
          child: const Text(
            'Сохранить',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(newValue),
        ),
        ]
      )
    ],
  )
);

    //update changes on Firestore
    if (newValue.trim().length > 0) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Настройки профиля'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
            .collection('user_info')
            .doc(currentUser.email)
            .snapshots(),
          builder: (context, snapshot) {
            //get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  SizedBox(height: 50),

                  //my details
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Детали',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                  //firstname
                    MyTextBox(
                      text: userData['Имя'],
                      sectionName: 'Имя',
                      onPressed: () => editField("Имя"),
                    ),

                  //lastname
                    MyTextBox(
                      text: userData['Фамилия'],
                      sectionName: 'Фамилия',
                      onPressed: () => editField("Фамилия"),
                    ),
                  
                  //phone number
                    MyTextBox(
                      text: userData['Номер_телефона'],
                      sectionName: 'Номер телефона',
                      onPressed: () => editField("Номер_телефона"),
                    ),
                ],
              );

            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            }

            return const Center(child: CircularProgressIndicator(),
            );
          }
        ),
    );
  }
}