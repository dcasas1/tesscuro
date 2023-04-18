import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './favorites_items.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key});

  @override
  Widget build(BuildContext context) {
    var newId = '';

    User? user = FirebaseAuth.instance.currentUser;
    newId = user!.uid;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(newId)
            .collection('accounts')
            .where('isFavorite', isEqualTo: true)
            .orderBy('siteName')
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data?.docs;
          return chatDocs!.isEmpty
              ? const Center(
                  //Button to add account if no accounts are in db
                  child: Text(
                  'Add Favorites On The Homepage!',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                  ),
                ))
              : ListView.separated(
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  itemCount: chatDocs.length,
                  itemBuilder: ((context, index) => InkWell(
                        child: FavItems(
                          siteName: chatDocs[index]['siteName'],
                          userName: chatDocs[index]['username'],
                          password: chatDocs[index]['password'],
                          docId: chatDocs[index].reference.id,
                          accountKey: ValueKey(chatDocs[index].id),
                          isFavorite: chatDocs[index]['isFavorite'],
                        ),
                      )),
                );
        });
  }
}
