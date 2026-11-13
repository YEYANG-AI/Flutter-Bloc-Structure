import 'package:flutter/material.dart';
import 'package:laoblogger/feature/home/widget/custom_bottom_nav.dart';

class AppRoutes {
  static const String home = '/home';

  static Map<String, Widget Function(BuildContext)> get routes => {
    home: (context) => CustomBottomNav(),
  };
}
