import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikstore/views/screens/auth/login_screen.dart';
import 'package:tikstore/views/screens/profile_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.to(LoginScreen());
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              final data = snapshot.data as QuerySnapshot;

              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  final user = data.docs[index];
                  return ListTile(
                    onTap: () {
                      Get.to(ProfileScreen(uid: user["uid"]));
                    },
                    leading: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user['profilePhoto']),
                    ),
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                    trailing: user['isVerified']
                        ? TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .update({
                                'isVerified': false,
                              });

                              FirebaseFirestore.instance
                                  .collection('videos')
                                  .where('uid', isEqualTo: user.id)
                                  .get()
                                  .then((value) {
                                value.docs.forEach((element) {
                                  FirebaseFirestore.instance
                                      .collection('videos')
                                      .doc(element.id)
                                      .update({
                                    'isVerified': false,
                                  });
                                });
                              });
                            },
                            child: const Text('Remove as Buyer'),
                          )
                        : TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.id)
                                  .update({
                                'isVerified': true,
                              });

                              // update in the videos collection

                              FirebaseFirestore.instance
                                  .collection('videos')
                                  .where('uid', isEqualTo: user.id)
                                  .get()
                                  .then((value) {
                                value.docs.forEach((element) {
                                  FirebaseFirestore.instance
                                      .collection('videos')
                                      .doc(element.id)
                                      .update({
                                    'isVerified': true,
                                  });
                                });
                              });
                            },
                            child: const Text('Verify as Buyer'),
                          ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          }),
    );
  }
}
