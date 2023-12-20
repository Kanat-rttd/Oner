import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oner/screens/art_category_pages/blog/create_blog_films.dart';
import 'package:oner/screens/art_category_pages/blog/crud_films.dart';

class FilmsPage extends StatefulWidget {
  const FilmsPage({super.key});

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
          return Column(
            children: <Widget>[
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BlogsTile(
                    docId: snapshot.data!.docs[index].id, // Добавляем docId
                    authorID: snapshot.data!.docs[index]['authorID'],
                    titleFilms: snapshot.data!.docs[index]['titleFilms'],
                    descriptionFilms: snapshot.data!.docs[index]
                        ['descriptionFilms'],
                    imgUrlFilms: snapshot.data!.docs[index]['imgUrlFilms'],
                  );
                },
              )
            ],
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
              // Действие при нажатии на иконку
            },
            icon: const Icon(Icons
                .fiber_smart_record_outlined), // Иконка (можете выбрать другую)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(child: blogListFilms()),
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

class BlogsTile extends StatelessWidget {
  final String imgUrlFilms, titleFilms, descriptionFilms, docId, authorID;
  BlogsTile({
    super.key,
    required this.docId,
    required this.imgUrlFilms,
    required this.titleFilms,
    required this.descriptionFilms,
    required this.authorID,
  });

  final currentUser = FirebaseAuth.instance.currentUser!;

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

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: SingleChildScrollView(
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imgUrlFilms,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
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
                              'Автор: ${authorNameFilms}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                              future:
                                  CrudMethodsFilms().isAuthor(docId, currentUser.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Ошибка при проверке авторства: ${snapshot.error}');
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
                                              content: const Text(
                                                  'Вы точно хотите удалить пост?'),
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
              ),
            ),
          );
        }
      },
    );
  }
}
