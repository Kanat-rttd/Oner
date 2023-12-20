import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oner/screens/art_category_pages/blog/crud_films.dart';
import 'dart:io';

import 'package:random_string/random_string.dart';

class CreateBlogFilms extends StatefulWidget {
  const CreateBlogFilms({super.key});

  @override
  State<CreateBlogFilms> createState() => CreateBlogFilmsState();
}

class CreateBlogFilmsState extends State<CreateBlogFilms> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  String filmUrl = '';
  String titleFilms = '';
  String descriptionFilms = '';

  XFile? selectedImageFilms;
  bool isLoadingFilms = false;

  CrudMethodsFilms crudMethodsFilms = CrudMethodsFilms();

  Future getImage() async {
    final pickerFilms = ImagePicker();
    XFile? imageFilms =
        await pickerFilms.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImageFilms = imageFilms;
    });
  }

  uploadBlog() async {
    if (selectedImageFilms != null) {
      setState(() {
        isLoadingFilms = true;
      });
      //uploading image to firebase storage
      Reference firebasStorageRef = FirebaseStorage.instance
          .ref()
          .child('blogImagesFilms')
          .child('${randomAlphaNumeric(9)}.jpg');

      final UploadTask taskFilms =
          firebasStorageRef.putFile(File(selectedImageFilms!.path));

      String downloadUrlFilms = await taskFilms.then((TaskSnapshot snapshot) {
        return snapshot.ref.getDownloadURL();
      });
      print('this is url $downloadUrlFilms');

      Map<String, String> blogMap = {
        'filmUrl': filmUrl,
        'imgUrlFilms': downloadUrlFilms,
        'titleFilms': titleFilms,
        'descriptionFilms': descriptionFilms,
        'authorID': FirebaseAuth.instance.currentUser!.uid,
      };

      crudMethodsFilms.addData(blogMap).then((resultFilms) {
        Navigator.pop(context);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Раздел ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Фильмов",
              style: TextStyle(fontSize: 22, color: Colors.white),
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
                child: const Icon(Icons.file_upload)),
          ),
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: isLoadingFilms
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
            child: Container(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: selectedImageFilms != null
                          ? Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    File(selectedImageFilms!.path),
                                    fit: BoxFit.cover,
                                  )),
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
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Имя автора: ${currentUser.displayName ?? ''}",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey[600]),
                            ),
                          ),
                          TextField(
                            maxLines: null,
                            decoration:
                                const InputDecoration(hintText: "Название"),
                            onChanged: (val) {
                              titleFilms = val;
                            },
                          ),
                          TextField(
                            maxLines: null,
                            decoration:
                                const InputDecoration(hintText: "Описание"),
                            onChanged: (val) {
                              descriptionFilms = val;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                hintText: "Ютуб ссылка на трейлер вашего фильма"),
                            onChanged: (val) {
                              filmUrl = val;
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('user_info')
                                .doc(currentUser.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Ошибка при получении данных: ${snapshot.error}');
                              } else {
                                Map<String, dynamic> userData =
                                    snapshot.data!.data() as Map<String, dynamic>;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: const Text(
                                        "Контактные данные:",
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.grey),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        "Номер телефона: ${userData['phoneNumber']}",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      height: 1,
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        "Емэйл: ${currentUser.email ?? 'Не указан'}",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}