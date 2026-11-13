import 'package:flutter/material.dart';
import 'package:laoblogger/core/styles/colors/app_colors.dart';
import 'package:laoblogger/feature/home/page/home_page.dart';
import 'package:laoblogger/feature/home/widget/nav_scope.dart';

class CustomBottomNav extends StatefulWidget {
  final int? currentIndex;
  const CustomBottomNav({super.key, this.currentIndex});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  late final ValueNotifier<int> _tabIndex = ValueNotifier<int>(
    widget.currentIndex ?? 0,
  );

  @override
  void dispose() {
    _tabIndex.dispose();
    super.dispose();
  }

  // Trade page is NOT a tab — it's pushed from the Watchlist.
  final List<Widget> _pages = const [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return NavScope(
      index: _tabIndex,
      child: ValueListenableBuilder<int>(
        valueListenable: _tabIndex,
        builder: (_, idx, __) => Scaffold(
          backgroundColor: Colors.black,
          body: IndexedStack(index: idx, children: _pages),
          bottomNavigationBar: Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SafeArea(
              top: true,
              bottom: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    "Home",
                    "assets/icons/home.png",
                    "assets/icons/home_active.png",
                    0,
                    idx,
                  ),
                  _buildNavItem(
                    "Market",
                    "assets/icons/home.png",
                    "assets/icons/home_active.png",
                    1,
                    idx,
                  ),
                  _buildNavItem(
                    "Trade",
                    "assets/icons/home.png",
                    "assets/icons/home_active.png",
                    2,
                    idx,
                  ),
                  _buildNavItem(
                    "Portfolio",
                    "assets/icons/home.png",
                    "assets/icons/home_active.png",
                    3,
                    idx,
                  ),
                  _buildNavItem(
                    "Profile",
                    "assets/icons/home.png",
                    "assets/icons/home_active.png",
                    4,
                    idx,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String label,
    String icon,
    String iconPressed,
    int index,
    int current,
  ) {
    final isSelected = current == index;
    return InkWell(
      onTap: () => _tabIndex.value = index,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 30,
            child: isSelected
                ? Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(iconPressed, width: 24),
                  )
                : Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(icon, width: 24),
                  ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
