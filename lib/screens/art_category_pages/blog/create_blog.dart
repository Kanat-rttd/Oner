import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oner/screens/art_category_pages/blog/crud.dart';
import 'dart:io';

import 'package:random_string/random_string.dart';


class CreateBlog extends StatefulWidget {
  const CreateBlog({super.key});

  @override
  State<CreateBlog> createState() => CreateBlogState();
}

class CreateBlogState extends State<CreateBlog> {

  String authorName = '';
  String title = '';
  String description = '';

  XFile? selectedImage;
  bool isLoading = false;

  CrudMethods crudMethods = CrudMethods();

  Future getImage() async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        isLoading = true;
      });
      //uploading image to firebase storage
      Reference firebasStorageRef = FirebaseStorage.instance
      .ref()
      .child('blogImages')
      .child('${randomAlphaNumeric(9)}.jpg');

      final UploadTask task = firebasStorageRef.putFile(File(selectedImage!.path));

      String downloadUrl = await task.then((TaskSnapshot snapshot) {
      return snapshot.ref.getDownloadURL();
    });
      print('this is url $downloadUrl');

      Map<String, String> blogMap = {
        'imgUrl': downloadUrl,
        'authorName': authorName,
        'title': title,
        'description': description,
      };

      crudMethods.addData(blogMap).then((result) {
        Navigator.pop(context);
      });
    }else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flutter",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.grey,
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.file_upload)
            ),
          ),
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
      : Container(
        child: Column(
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: selectedImage != null ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(File(selectedImage!.path), fit: BoxFit.cover,)),
              )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                width: MediaQuery.of(context).size.width,
                child: const Icon(Icons.add_a_photo),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: "Имя автора"),
                    onChanged: (val) {
                      authorName = val;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Название"),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Описание"),
                    onChanged: (val) {
                      description = val;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),   
      ),
    );  
  }
}