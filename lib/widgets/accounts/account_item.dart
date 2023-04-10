import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './account_list.dart';
import '../../screens/addcredentials.dart';
import '../../screens/editsettings.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context) {
    void addRoute(BuildContext ctx) {
      Navigator.of(context).pushNamed(AddCredentials.routeName);
    }

    var newId = '';
    Future(() async {
      User? user = FirebaseAuth.instance.currentUser;
      newId = user!.uid;
    });

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('accounts')
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
              ? Center(
                  //Button to add account if no accounts are in db
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => addRoute(ctx),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          child: const Text('Tap Here To Add An Account'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  itemCount: chatDocs.length,
                  itemBuilder: ((context, index) => InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                          EditSettings.routeName, arguments: chatDocs[index].reference.id,
                        ),
                        child: AccountList(
                          siteName: chatDocs[index]['siteName'],
                          userName: chatDocs[index]['username'],
                          password: chatDocs[index]['password'],
                          docId: chatDocs[index].reference.id,
                          isMe: chatDocs[index]['userId'] == newId,
                          accountKey: ValueKey(chatDocs[index].id),
                        ),
                      )),
                );
        });
  }
}
