import 'package:equatable/equatable.dart';
import 'package:laoblogger/feature/home/domain/home_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus homeStatus;
  final List<HomeModel> homeModel;
  const HomeState({
    this.homeStatus = HomeStatus.initial,
    this.homeModel = const [],
  });

  HomeState copyWith({HomeStatus? homeStatus, List<HomeModel>? homeModel}) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      homeModel: homeModel ?? this.homeModel,
    );
  }

  @override
  List<Object?> get props => [homeStatus, homeModel];
}
