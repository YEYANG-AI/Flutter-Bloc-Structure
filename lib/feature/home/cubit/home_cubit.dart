import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laoblogger/feature/home/cubit/home_state.dart';
import 'package:laoblogger/feature/home/data/repositories/home_repositories.dart';
import 'package:laoblogger/feature/home/domain/home_mock_data.dart';
import 'package:laoblogger/feature/home/domain/home_model.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepositories _homeRepositories;
  HomeCubit({required HomeRepositories homeRepository})
    : _homeRepositories = homeRepository,
      super(const HomeState(homeStatus: HomeStatus.initial));

  Future<void> getAllStocks() async {
    emit(state.copyWith(homeStatus: HomeStatus.loading));
    try {
      final List<HomeModel> stocks = mockStocks;
      emit(state.copyWith(homeStatus: HomeStatus.success, homeModel: stocks));
    } catch (e) {
      emit(state.copyWith(homeStatus: HomeStatus.failure));
    }
  }
}
