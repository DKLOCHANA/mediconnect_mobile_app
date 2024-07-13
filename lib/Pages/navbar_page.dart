import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/Pages/add.dart';
import 'package:mediconnect/Pages/home_pagemain.dart';
import 'package:mediconnect/Pages/profile.dart';
import 'package:mediconnect/Pages/store.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with WidgetsBindingObserver {
  int _pageIndex = 0;
  bool _isKeyboardVisible = false;

  final List<Widget> _pages = [
    MainHomePage(),
    StorePage(),
    Add(),
    ProfileScreen(onPressed: () {}),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_pageIndex],
          if (!_isKeyboardVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CurvedNavigationBar(
                backgroundColor: Colors.transparent,
                buttonBackgroundColor: Colors.blue,
                color: Colors.blue,
                animationDuration: const Duration(milliseconds: 300),
                items: const <Widget>[
                  Icon(Icons.home, size: 26, color: Colors.white),
                  Icon(Icons.store_mall_directory_sharp,
                      size: 26, color: Colors.white),
                  Icon(Icons.add, size: 26, color: Colors.white),
                  Icon(Icons.person, size: 26, color: Colors.white),
                ],
                onTap: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
