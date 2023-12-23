import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oner/screens/bottom_navigation/chatting/chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, int> unreadMessagesCount = {};

  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('user_info').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Ошибка');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Загрузка...');
        }

        final List<Widget> userListItems = [];
        final List<String> usersWithChats = [];

        snapshot.data!.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final String userEmail = data['email'];
          final String userID = data['uid'];
          final String userName = '${data['firstName']} ${data['lastName']}';

          if (_auth.currentUser!.email != userEmail) {
            usersWithChats.add(userID);

            int unreadCount = unreadMessagesCount[userID] ?? 0;

            userListItems.add(
              ListTile(
                title: Text(userName),
                leading: FutureBuilder<String>(
                  future: _getAvatarURL(userID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar();
                    } else {
                      final avatarUrl = snapshot.data ?? '';
                      return CircleAvatar(
                        backgroundImage: avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : const AssetImage('assets/default-avatar.png')
                                as ImageProvider<Object>,
                      );
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        recieverUserEmail: userName,
                        recieverUserID: userID,
                      ),
                    ),
                  );
                  setState(() {
                    unreadMessagesCount[userID] = 0;
                  });
                },
                trailing: unreadCount > 0
                    ? CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 10,
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          }
        });

        if (usersWithChats.isNotEmpty) {
          return ListView(children: userListItems);
        } else {
          return const Center(child: Text('Пока нет чатов'));
        }
      },
    );
  }

  Future<String> _getAvatarURL(String userID) async {
    try {
      final storageReference =
          FirebaseStorage.instance.ref().child('avatars/avatar_$userID.jpg');
      final downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Ошибка при загрузке изображения из Firebase Storage: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сообщения'),
        centerTitle: true,
      ),
      body: _buildUserList(),
    );
  }
}
