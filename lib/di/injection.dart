// di/injection.dart - แบบที่ถูกต้อง
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laoblogger/feature/home/cubit/home_cubit.dart';
import 'package:laoblogger/feature/home/data/repositories/home_repositories.dart';
import 'package:laoblogger/feature/home/data/services/home_services.dart';

List<RepositoryProvider> _getDataLayerDependencies() {
  return [
    RepositoryProvider<HomeServices>(create: (_) => HomeServices()),

    RepositoryProvider<HomeRepositories>(
      create: (context) => HomeRepositories(),
    ),
  ];
}

List<BlocProvider> _getPresentationLayerDependencies() {
  return [
    BlocProvider<HomeCubit>(
      create: (context) =>
          HomeCubit(homeRepository: HomeRepositories())..getAllStocks(),
    ),
  ];
}

List<RepositoryProvider> getAllRepositoryProviders() {
  return [..._getDataLayerDependencies()];
}

List<BlocProvider> getAllBlocProviders() {
  return _getPresentationLayerDependencies();
}
