import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tikstore/constants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String videoID;
  final String ownerID;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.videoID,
    required this.ownerID,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPress: () => widget.ownerID == firebaseAuth.currentUser!.uid
          ? _showDeleteDialog(context, widget.videoID)
          : null,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: VideoPlayer(videoPlayerController),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String videoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Video'),
          content: const Text('Are you sure you want to delete this video?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => _deleteVideo(context, videoId),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteVideo(BuildContext context, String videoId) async {
    try {
      // Example Firestore deletion, replace 'videos' with your actual collection path
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId) // Use the video's unique ID to delete
          .delete();

      Navigator.of(context).pop(); // Close the dialog

      // Optionally, pop the current route if you want to return to the previous screen after deletion
      // Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting video: $e')),
      );
    }
  }
}
