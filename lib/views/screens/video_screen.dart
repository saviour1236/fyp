import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tikstore/constants.dart';
import 'package:tikstore/controllers/video_controller.dart';
import 'package:tikstore/models/video.dart';
import 'package:tikstore/views/screens/checkoutscreen.dart';
import 'package:tikstore/views/screens/comment_screen.dart';
import 'package:tikstore/views/screens/profile_screen.dart';
import 'package:tikstore/views/widgets/circle_animation.dart';
import 'package:tikstore/views/widgets/video_player_item.dart';
import 'package:get/get.dart';

class VideoScreen extends StatelessWidget {
  final String? uid;
  VideoScreen({
    Key? key,
    this.uid,
  }) : super(key: key);

  final VideoController videoController = Get.put(VideoController());

  buildProfile(String profilePhoto, {required String uid}) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: GestureDetector(
            onTap: () {
              Get.to(ProfileScreen(
                uid: uid,
                ownprofile: firebaseAuth.currentUser!.uid == uid,
              ));
            },
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: uid == null
            ? null
            : AppBar(
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
        body: StreamBuilder<Object>(
            stream: uid != null
                ? FirebaseFirestore.instance
                    .collection('videos')
                    .where('uid', isEqualTo: uid)
                    .snapshots()
                : FirebaseFirestore.instance.collection('videos').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.hasData) {
                final List<Video> videos = [];
                final data =
                    snapshot.data as QuerySnapshot<Map<String, dynamic>>;

                for (final video in data.docs) {
                  videos.add(Video.fromSnap(video.data()));
                }

                if (videos.isEmpty) {
                  return const Center(
                    child: Text('No videos found'),
                  );
                }

                return PageView.builder(
                  itemCount: videos.length,
                  controller:
                      PageController(initialPage: 0, viewportFraction: 1),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final data = videos[index];

                    return Stack(
                      children: [
                        VideoPlayerItem(
                          videoUrl: data.videoUrl,
                          videoID: data.id,
                          ownerID: data.uid,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ProfileScreen(
                                                    uid: data.uid,
                                                    ownprofile: firebaseAuth
                                                            .currentUser!.uid ==
                                                        data.uid,
                                                  ));
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.username,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    data.isVerified
                                                        ? const Icon(
                                                            Icons.verified,
                                                            color: Colors.blue,
                                                            size: 18,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                data.caption,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              data.price == null
                                                  ? SizedBox.shrink()
                                                  : Text(
                                                      data.price.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                              data.price == null
                                                  ? SizedBox.shrink()
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: InkWell(
                                                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (_) => CheckoutScreen(
                                                                sellerId:
                                                                    data.uid,
                                                                thumbnailUrl: data
                                                                    .thumbnail,
                                                                sellerUsername:
                                                                    data
                                                                        .username,
                                                                sellerNumber: data
                                                                    .username,
                                                                productName: data
                                                                    .productName,
                                                                price:
                                                                    data.price ??
                                                                        0.0,
                                                                productDescription:
                                                                    data.caption))),
                                                        child: Container(
                                                          height: 40,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: const Center(
                                                            child:
                                                                Text('Buy now'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.music_note,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    data.songName,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(top: size.height / 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          buildProfile(
                                            data.profilePhoto,
                                            uid: data.uid,
                                          ),
                                          SizedBox(
                                            height: 24,
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () => videoController
                                                    .likeVideo(data.id),
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 40,
                                                  color: data.likes.contains(
                                                          firebaseAuth
                                                              .currentUser!.uid)
                                                      ? Colors.red
                                                      : Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 7),
                                              Text(
                                                data.likes.length.toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 24,
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CommentScreen(
                                                      id: data.id,
                                                    ),
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.comment,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 7),
                                              Text(
                                                data.commentCount.toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 24,
                                          ),
                                          CircleAnimation(
                                            child: buildMusicAlbum(
                                                data.profilePhoto),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }

              return SizedBox.shrink();
            }));
  }
}
