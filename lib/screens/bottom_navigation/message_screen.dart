import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:oner/screens/chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;

  User(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.email});
}

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return User(
          uid: user.uid, firstName: '', lastName: '', email: user.email ?? '');
    }
    return null;
  }

  Future<List<User>> getUsers(String currentUserId) async {
    final snapshot = await _firestore.collection('user_info').get();
    return snapshot.docs
        .map((doc) => User(
              uid: doc['uid'],
              firstName: doc['firstName'],
              lastName: doc['lastName'],
              email: doc['email'],
            ))
        .where((user) =>
            user.uid != currentUserId) // Исключаем текущего пользователя
        .toList();
  }

  Future<String?> getAvatarUrl(String uid) async {
    try {
      final path = 'avatars/avatar_$uid.jpg';
      return await _storage.ref().child(path).getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}

class MessageBloc extends Cubit<List<User>> {
  final FirebaseService _firebaseService = FirebaseService();

  MessageBloc() : super([]);

  Future<void> loadUsers() async {
    final currentUser = await _firebaseService.getCurrentUser();
    if (currentUser != null) {
      final users = await _firebaseService.getUsers(currentUser.uid);
      emit(users);
    }
  }
}

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Page'),
      ),
      body: BlocProvider(
        create: (context) => MessageBloc()..loadUsers(),
        child: _UserList(),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, List<User>>(
      builder: (context, users) {
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _UserListItem(user: user);
          },
        );
      },
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User user;

  const _UserListItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FutureBuilder(
        future: FirebaseService().getAvatarUrl(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircleAvatar(); // Placeholder until the avatar is loaded
          } else if (snapshot.hasError) {
            return const CircleAvatar(); // Placeholder for error
          } else {
            return CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data.toString()),
            );
          }
        },
      ),
      title: Text('${user.firstName} ${user.lastName}'),
      onTap: () {
        // pass the clicked user's uid to the chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserEmail: user.email,
              receiverUserID: user.uid,
              recieverUserEmail: '',
              recieverUserID: '',
            ),
          ),
        );
      },
    );
  }
}
