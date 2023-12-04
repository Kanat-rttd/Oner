import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oner/screens/art_category_pages/blog/create_blog.dart';
import 'package:oner/screens/art_category_pages/blog/crud.dart';


class FilmsPage extends StatefulWidget {
  const FilmsPage({super.key});

  @override
  State<FilmsPage> createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  CrudMethods crudMethods = CrudMethods();

  late Future<QuerySnapshot> blogsFuture;

  @override
  void initState() {
    super.initState();

    blogsFuture = crudMethods.getData();
  }

  Widget blogList() {
    return FutureBuilder(
      future: blogsFuture,
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
                    authorName: snapshot.data!.docs[index]['authorName'],
                    title: snapshot.data!.docs[index]['title'],
                    description: snapshot.data!.docs[index]['description'],
                    imgUrl: snapshot.data!.docs[index]['imgUrl'],
                  );
                },
              )
            ],
          );
        }
      },
    );
  }

  // @override
  // void initState() {
  //   super.initState();

  //   crudMethods.getData().then((result){
  //     blogsSnapshot = result;
  //   });
  // }

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
            ),
          ],
        ),
        
        backgroundColor: Colors.grey,
        // elevation: 0.0,
      ),
      body: SingleChildScrollView(child: blogList()),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: const Icon(Icons.add),
            )
          ]
        )
      ),  
    );
  }
}


class BlogsTile extends StatelessWidget {

  final String imgUrl, title, description, authorName;
  const BlogsTile({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.description,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 300,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )),
            Container(
              height: 400,
              decoration: BoxDecoration(color: Colors.black45.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    authorName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}