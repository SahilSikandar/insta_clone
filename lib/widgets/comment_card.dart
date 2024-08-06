import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  final snap;
  final String postId;
  const CommentCard({super.key, required this.snap, required this.postId});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.only(left: 16, right: 8),
      child: Row(children: [
        CircleAvatar(
            radius: 18, backgroundImage: NetworkImage(snap['profile'])),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 8, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: snap['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    WidgetSpan(
                      child: SizedBox(width: 5), // Adjust the width as needed
                    ),
                    TextSpan(
                      text: snap['text'],
                      //style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format((snap['publishedDate'] as Timestamp).toDate())
                        .toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            IconButton(
              icon: Icon(
                snap['likes'].contains(user.uid)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: snap['likes'].contains(user.uid)
                    ? Colors.red
                    : Colors.white,
              ),
              onPressed: () async {
                await FireStoreMethods().commentLike(
                    user.uid, snap['likes'], postId, snap['commentId']);
              },
            ),
            Text('${snap['likes'].length} likes')
          ],
        ),
      ]),
    );
  }
}
