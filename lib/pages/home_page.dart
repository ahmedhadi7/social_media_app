import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/component/drawer.dart';
import 'package:social_media/component/text_field.dart';
import 'package:social_media/component/wall_post.dart';
import 'package:social_media/helper/helper_method.dart';
import 'package:social_media/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser;


  final textController = TextEditingController();

  //sign user out
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //post message
  void postMessage() async {
    //only post
    if (textController.text.trim().isNotEmpty && currentUser != null) {
      //store firestore
      await FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser!.email,
        'Message': textController.text.trim(),
        'TimeStamp': Timestamp.now(),
        'Likes' : [],
      });
    }
    setState(() {
      textController.clear();
      });
  }
  //navigate to profile page
  void goToProfilePage(){
  
      Navigator.pop(context);
    
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));


  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Social Media'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: signOut),
        ],
      ),
      drawer: mydrawer(onProfileTap: goToProfilePage, onSignOut: signOut),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final posts = snapshot.data!.docs;

                    if (posts.isEmpty) {
                      return const Center(child: Text('No posts yet'));
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        //get the message
                        final post = posts[index];
                        final postData = post.data() as Map<String, dynamic>;

                        return WallPost(
                          message: postData['Message'],
                          user: postData['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error:${snapshot.error})'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  //text field
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Write something here',
                      obscureText: false,
                    ),
                  ),

                  //post button
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),

            //
          ],
        ),
      ),
    );
  }
}
