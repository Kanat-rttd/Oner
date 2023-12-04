import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/additional/chat_bubble.dart';
import 'package:oner/additional/textfield.dart';
import 'package:oner/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserName;
  final String recieverUserID;
  const ChatPage({
    super.key,
    required this.recieverUserName,
    required this.recieverUserID,
  });

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.recieverUserID, _messageController.text
      );
      //clear the text controller after sending message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recieverUserName)),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(), 
          ),

          //user input
          _builMessageInput(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.recieverUserID,
        _firebaseAuth.currentUser!.uid
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
            .map((document) => _buildMessageItem(document))
            .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
    ? Alignment.centerRight
    : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderID'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderID'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(data['senderName']),
          const SizedBox(height: 5),
          ChatBubble(message: data['message']),
        ],
      ),
    );
  }

  //build message input
  Widget _builMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false
            ), 
          ),
    
          //send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}