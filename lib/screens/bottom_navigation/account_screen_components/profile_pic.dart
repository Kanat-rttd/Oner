import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (docSnapshot.exists) {
        final imageUrl = docSnapshot.get('avatarUrl');
        if (imageUrl != null && imageUrl.isNotEmpty) {
          // Load image from network
          final imageFile = await _loadImageFromNetwork(imageUrl);
          if (imageFile != null) {
            setState(() {
              _image = imageFile;
            });
          }
        }
      }
    } catch (e) {
      print('Ошибка при загрузке изображения: $e');
    }
  }

  Future<File?> _loadImageFromNetwork(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/temp_avatar.jpg');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print('Ошибка при загрузке изображения из сети: $e');
    }
    return null;
  }

  Future<void> _saveImage(File image) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image', image.path);
  }

  Future<void> _handleImageSelection() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        await _saveImage(_image!);

        // Upload image to Firebase Storage and update Firestore
        await _uploadImageToFirebaseStorage(_image!);
      }
    } catch (e) {
      print('Ошибка при выборе изображения: $e');
    }
  }

  Future<void> _uploadImageToFirebaseStorage(File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final fileName = 'avatar_${user?.uid}.jpg';
      final storageReference =
          FirebaseStorage.instance.ref().child('avatars/$fileName');
      await storageReference.putFile(image);
      final downloadUrl = await storageReference.getDownloadURL();

      // Получение ссылки на документ пользователя
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user?.uid);

      // Проверка на существование документа
      final userDocSnapshot = await userDoc.get();

      if (userDocSnapshot.exists) {
        // Если документ существует, обновите его с новым URL изображения
        await userDoc.update({'avatarUrl': downloadUrl});
      } else {
        // Если документ не существует, создайте его с новым URL изображения
        await userDoc.set({'avatarUrl': downloadUrl});
      }

      print('Firestore обновлен с URL изображения: $downloadUrl');
    } catch (e) {
      print(
          'Ошибка при загрузке изображения в Firebase Storage или обновлении Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: _image != null
                ? FileImage(_image!)
                : const AssetImage(
                        'assets/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg')
                    as ImageProvider,
          ),
          Positioned(
            right: -10,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F6F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: _handleImageSelection,
                child: SvgPicture.asset("assets/photo-camera-svgrepo-com.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
