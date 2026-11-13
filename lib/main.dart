import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laoblogger/core/routes/app_routes.dart';
import 'package:laoblogger/di/injection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: getAllRepositoryProviders(),
      child: MultiBlocProvider(
        providers: getAllBlocProviders(),
        child: MaterialApp(
          title: 'Investing',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.home,
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}
