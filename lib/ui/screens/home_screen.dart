import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nasa_cosmos_messenger/ui/screens/nova_chat_screen.dart';
import 'package:nasa_cosmos_messenger/ui/screens/favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const NovaChatScreen(), const FavoriteScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Ionicons.planet_outline),
            selectedIcon: Icon(Ionicons.planet),
            label: 'Nova',
          ),
          NavigationDestination(
            icon: Icon(Ionicons.star_outline),
            selectedIcon: Icon(Ionicons.star),
            label: '收藏',
          ),
        ],
      ),
    );
  }
}
