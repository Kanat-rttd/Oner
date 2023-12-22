import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/additional/chat_bubble.dart';
import 'package:oner/additional/textfield.dart';
import 'package:oner/screens/bottom_navigation/chatting/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserID;
  const ChatPage({
    super.key,
    required this.recieverUserEmail,
    required this.recieverUserID,
  });

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void replyToMessage(
      String messageId, String senderEmail, String originalMessage) {
    // Implement your reply logic here
    print('Replying to message with ID: $messageId');
    print('Sender: $senderEmail');
    print('Original Message: $originalMessage');
    // You can open a reply input or navigate to a new screen for the reply
  }

  void sendMessage() async {
    //only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverUserID, _messageController.text);
      //clear the text controller after sending message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recieverUserEmail)),
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
          widget.recieverUserID, _firebaseAuth.currentUser!.uid),
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

    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Dismissible(
      key: UniqueKey(), // Use UniqueKey for each Dismissible
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.green, // Customize swipe background color
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.reply,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        // Handle swipe action (reply)
        replyToMessage(
          document.id,
          data['senderEmail'],
          data['message'],
        );
      },
      child: GestureDetector(
        onLongPress: () {
          // Handle long-press action (reply)
          replyToMessage(
            document.id,
            data['senderEmail'],
            data['message'],
          );
        },
        child: Container(
          alignment: alignment,
          child: Column(
            crossAxisAlignment:
                (data['senderID'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderID'] == _firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              Text(data['senderEmail']),
              const SizedBox(height: 5),
              ChatBubble(
                message: data['message'],
                time: _formatTimestamp(data['timestamp']),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Format timestamp to display time
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return formattedTime;
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
                obscureText: false),
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