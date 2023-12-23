import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/screens/art_category_pages/blog/create_blog_films.dart';
import 'package:oner/screens/art_category_pages/blog/crud_films.dart';
// import 'package:oner/chat/chat_page.dart';
import 'package:oner/screens/bottom_navigation/chatting/chat_screen.dart'; // Import your ChatPage

class FilmsPage extends StatefulWidget {
  const FilmsPage({Key? key});

  @override
  State<FilmsPage> createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  CrudMethodsFilms crudMethodsFilms = CrudMethodsFilms();
  late Future<QuerySnapshot> blogsFutureFilms;

  @override
  void initState() {
    super.initState();

    blogsFutureFilms = crudMethodsFilms.getData();
  }

  // Method to navigate to the blog creation page for editing
  void _navigateToEditPost(BlogsTile tile) async {
    Map<String, dynamic>? updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateBlogFilms(
          initialData: {
            'filmUrl': tile.filmUrl,
            'titleFilms': tile.titleFilms,
            'descriptionFilms': tile.descriptionFilms,
            // ... Other fields ...
          },
          docId: tile.docId,
          isEditing: true,
        ),
      ),
    );

    // If there are updated data, update the UI
    if (updatedData != null) {
      setState(() {
        tile.filmUrl = updatedData['filmUrl'];
        tile.titleFilms = updatedData['titleFilms'];
        tile.descriptionFilms = updatedData['descriptionFilms'];
        // ... Update other fields as needed ...
      });
    }
  }

  Widget blogListFilms() {
    return FutureBuilder(
      future: blogsFutureFilms,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Ошибка при получении данных: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('Нет доступных блогов.');
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return BlogsTile(
                docId: snapshot.data!.docs[index].id,
                authorID: snapshot.data!.docs[index]['authorID'],
                titleFilms: snapshot.data!.docs[index]['titleFilms'],
                descriptionFilms: snapshot.data!.docs[index]['descriptionFilms'],
                filmUrl: snapshot.data!.docs[index]['filmUrl'],
                imgUrlFilms: snapshot.data!.docs[index]['imgUrlFilms'],
                navigateToEditPost: _navigateToEditPost,
              );
            },
          );
        }
      },
    );
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
            ),
          ],
        ),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            onPressed: () {
              // Placeholder for the action when the icon is pressed
            },
            icon: const Icon(
              Icons.fiber_smart_record_outlined,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: blogListFilms(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBlogFilms()),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// ignore: must_be_immutable
class BlogsTile extends StatelessWidget {
  String imgUrlFilms, titleFilms, descriptionFilms, filmUrl, docId, authorID;
  final Function(BlogsTile) navigateToEditPost; // Add this line

  BlogsTile({
    required this.docId,
    required this.imgUrlFilms,
    required this.titleFilms,
    required this.descriptionFilms,
    required this.filmUrl,
    required this.authorID,
    required this.navigateToEditPost, // Add this line
  });

  final currentUser = FirebaseAuth.instance.currentUser!;


  // Method to navigate to the blog creation page for editing
  void _editPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateBlogFilms(
          // Pass post details to the blog creation page
          initialData: {
            'imgUrlFilms': imgUrlFilms,
            'titleFilms': titleFilms,
            'descriptionFilms': descriptionFilms,
          },
          // Pass the document ID for updating the post
          docId: docId,
          isEditing: true,
        ),
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('user_info')
          .doc(authorID)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Ошибка при получении данных: ${snapshot.error}');
        } else {
          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
          String authorNameFilms =
              '${userData['firstName']} ${userData['lastName']}';
              
          bool isCurrentUserAuthor = currentUser.uid == authorID;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imgUrlFilms,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // IconButton for navigating to chat page
                        if (!isCurrentUserAuthor)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(Icons.message),
                              onPressed: () {
                                // Navigate to chat page with the author
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      recieverUserEmail: userData['email'],
                                      recieverUserID: authorID,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleFilms,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            descriptionFilms,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filmUrl,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Автор: $authorNameFilms',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('user_info')
                                .doc(authorID)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Ошибка при получении данных: ${snapshot.error}');
                              } else {
                                Map<String, dynamic> userData = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: const Text(
                                        "Контактные данные:",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
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
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        "Email: ${userData['email'] ?? 'Не указан'}",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder(
                            future: CrudMethodsFilms().isAuthor(docId, currentUser.uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Ошибка при проверке авторства: ${snapshot.error}');
                              } else {
                                bool isAuthor = snapshot.data as bool;
          
                                if (isAuthor) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      // Диалоговое окно подтверждения удаления
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Удаление поста'),
                                            content: const Text('Вы точно хотите удалить пост?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                                child: const Text('Отмена'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                                child: const Text('Удалить'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
          
                                      // Если подтвердили удаление, удаляем пост
                                      if (confirmDelete == true) {
                                        await CrudMethodsFilms().deleteData(docId);
                                        // Обновляем UI (например, перезагружаем страницу)
                                      }
                                    },
                                    child: const Text('Удалить пост'),
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          );
          
        }
      },
    );
  }
}