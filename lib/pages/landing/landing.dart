import 'package:campus_thrift/services/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late PageController _pageController;
  int _currentPage = 0;

  Future<bool> getOnboarded() {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool('onboarded') ?? false;
    });
  }

  Future<void> setOnboarded() {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.setBool('onboarded', true);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                Center(
                  child: Text('Page 1'),
                ),
                Center(
                  child: Text('Page 2'),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_currentPage == 1) {
                if (await (getOnboarded()) == false) {
                  setOnboarded();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthHandler()),
                );
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );

                setState(() {
                  _currentPage++;
                });
              }
            },
            child: _currentPage == 1 ? Text('Finish') : Text('Next'),
          ),
        ],
      )),
    );
  }
}
