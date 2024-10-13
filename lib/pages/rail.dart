import 'package:campus_cart/pages/home/add_post.dart';
import 'package:campus_cart/pages/home/bookmarks.dart';
import 'package:campus_cart/pages/home/home_page.dart';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RailPage extends StatefulWidget {
  @override
  _RailPageState createState() => _RailPageState();
}

class _RailPageState extends State<RailPage> {
  // Track the selected index for the BottomNavigationBar and PageView
  int _selectedIndex = 0;

  // PageController to manage the PageView
  PageController _pageController = PageController();

  // Handle the index change from BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Move to selected page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex =
                index; // Update BottomNavigationBar when page changes
          });
        },
        children: [
          HomePage(), // Page 1
          Bookmarks(),
          AddPostPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.plus),
            label: 'Add Post',
          ),
        ],
      ),
    );
  }
}
