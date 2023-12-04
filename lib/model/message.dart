import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderName;
  final String recieverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderName,
    required this.recieverID,
    required this.message,
    required this.timestamp,
  });

  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderName': senderName,
      'recieverID': recieverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}