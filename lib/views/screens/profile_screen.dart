import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikstore/constants.dart';
import 'package:tikstore/controllers/profile_controller.dart';
import 'package:tikstore/models/video.dart';
import 'package:tikstore/views/screens/auth/login_screen.dart';
import 'package:tikstore/views/screens/edit_profile_screen.dart';
import 'package:tikstore/views/screens/video_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final bool ownprofile;
  const ProfileScreen({
    Key? key,
    required this.uid,
    this.ownprofile = false,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid, widget.ownprofile);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black12,
              actions: const [
                Icon(Icons.more_horiz),
              ],
              title: Row(
                children: [
                  Text(
                    controller.user['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  controller.user['isVerified']
                      ? const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Something went wrong'));
                                }

                                if (snapshot.hasData) {
                                  final data = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  print(data);
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: data['profilePhoto'],
                                              height: 100,
                                              width: 100,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.error,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        controller.user['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                controller.user['following'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              const Text(
                                                'Following',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            color: Colors.black54,
                                            width: 1,
                                            height: 15,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                controller.user['followers'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              const Text(
                                                'Followers',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            color: Colors.black54,
                                            width: 1,
                                            height: 15,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                controller.user['likes'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              const Text(
                                                'Likes',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // Changed to center to reduce space
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                // Added padding to fine-tune spacing
                                                padding: const EdgeInsets.only(
                                                    left: 110,
                                                    right:
                                                        5), // Adjust these values as needed
                                                child: Container(
                                                  height: 47,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (widget.uid ==
                                                            firebaseAuth
                                                                .currentUser!
                                                                .uid) {
                                                          authController
                                                              .signOut();
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
                                                                              LoginScreen()));
                                                        } else {
                                                          controller
                                                              .followUser();
                                                        }
                                                      },
                                                      child: Text(
                                                        widget.uid ==
                                                                firebaseAuth
                                                                    .currentUser!
                                                                    .uid
                                                            ? 'Sign Out'
                                                            : (controller.user[
                                                                    'isFollowing']
                                                                ? 'Unfollow'
                                                                : 'Follow'),
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                // Added padding to fine-tune spacing
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    right:
                                                        110), // Adjust these values as needed
                                                child: Container(
                                                  height: 47,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        // Navigate to the Edit Profile Screen (to be created)
                                                        Get.to(() =>
                                                            EditProfileScreen());
                                                      },
                                                      child: const Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('videos')
                                  .where('uid', isEqualTo: widget.uid)
                                  .snapshots(),
                              builder: (context, snapshots) {
                                if (snapshots.hasData) {
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: snapshots.data!.docs.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 5,
                                    ),
                                    itemBuilder: (context, index) {
                                      var data = snapshots.data!.docs[index];

                                      Video video = Video.fromSnap(data.data());

                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => VideoScreen(
                                                uid: video.uid,
                                              ));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: video.thumbnail,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  );
                                }
                                return CircularProgressIndicator();
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
