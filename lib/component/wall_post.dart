import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/component/comment.dart';
import 'package:social_media/component/comment_button.dart';
import 'package:social_media/component/delete_button.dart';
import 'package:social_media/component/like_button.dart';
import 'package:social_media/helper/helper_method.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;
  final _commentTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  //togle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //access the doucument is firebase
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId);
    if (isLiked) {
      //if the post is now liked
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser!.email]),
      });
    } else {
      //if the post in now unliked
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser!.email]),
      });
    }
  }

  // add comment
  void addComment(String commentText) {
    //comment to firestore
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
          "CommentText": commentText,
          "CommentBy": currentUser!.email,
          "CommentTime": Timestamp.now(),
        });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment'),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
        ],
      ),
    );

    // delete a post
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          //delete
          TextButton(
            onPressed: () async {
              final commentDocs = await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();
              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }
              //then delete the post
              FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("post deleted"))
                  .catchError((error) => print("field to delete post: $error"));
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          //wall post
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.message, softWrap: true),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.user,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),

                        Text(" * ", style: TextStyle(color: Colors.grey[400])),

                        Text(
                          widget.time,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (widget.user == currentUser!.email)
                DeleteButton(onTap: deletePost),
            ],
          ),

          const SizedBox(width: 20),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //like
              Column(
                children: [
                  //like button
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(height: 5),

                  //like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(width: 10),

              //comment
              Column(
                children: [
                  //comment button
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(height: 5),

                  //like count
                  Text("0", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          //comment under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //show loading circle
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                shrinkWrap: true, //for nested lists
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comment
                  final commentData = doc.data() as Map<String, dynamic>;

                  final commentText =
                      commentData["CommentText"] as String? ?? '';
                  final commentBy = commentData["CommentBy"] as String? ?? '';
                  final commentTime = commentData["CommentTime"] as Timestamp?;

                  return Comment(
                    text: commentText,
                    user: commentBy,
                    time: commentTime != null ? formatDate(commentTime) : '',
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
