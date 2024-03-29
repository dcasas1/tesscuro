import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'account_item.dart';
import '../../screens/addcredentials.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context) {
    void addRoute(BuildContext ctx) {
      Navigator.of(context).pushNamed(AddCredentials.routeName);
    }

    var newId = '';

    User? user = FirebaseAuth.instance.currentUser;
    newId = user!.uid;

    //Stream allows constant communication so UI updates when Firebase updates
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(newId)
            .collection('accounts')
            .orderBy('siteName')
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //Grabs all the accounts associated to the user logged in
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
                
              :
              //Passes each account to account_item file to build a tile for each 
              ListView.separated(
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  itemCount: chatDocs.length,
                  itemBuilder: ((context, index) => InkWell(
                        child: AccountList(
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
