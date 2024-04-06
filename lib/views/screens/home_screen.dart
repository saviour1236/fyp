import 'package:flutter/material.dart';
import 'package:tikstore/constants.dart';
import 'package:tikstore/views/screens/cart_screen.dart';
import 'package:tikstore/views/screens/profile_screen.dart';
import 'package:tikstore/views/screens/search_screen.dart';
import 'package:tikstore/views/screens/upload_videoscreen.dart';
import 'package:tikstore/views/screens/video_screen.dart';
import 'package:tikstore/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  List pages = [
    VideoScreen(),
    SearchScreen(),
    const AddVideoScreen(),
    const CartScreen(),
    ProfileScreen(
      uid: firebaseAuth.currentUser!.uid,
      ownprofile: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: pageIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop, size: 30),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
