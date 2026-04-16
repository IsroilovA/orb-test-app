import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orb_test_app/src/features/home/common/model/home_overview.dart';
import 'package:orb_test_app/src/features/home/data/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

final class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const HomeState()) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        HomeStarted() => _onStarted(event, emit),
        HomeRetried() => _onRetried(event, emit),
      },
      transformer: sequential(),
    );
  }

  final HomeRepository _homeRepository;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    await _loadOverview(emit);
  }

  Future<void> _onRetried(HomeRetried event, Emitter<HomeState> emit) async {
    await _loadOverview(emit);
  }

  Future<void> _loadOverview(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final overview = await _homeRepository.loadOverview();
      emit(state.copyWith(overview: overview, isLoading: false, clearError: true));
    } on Object catch (error) {
      emit(state.copyWith(isLoading: false, error: error));
    }
  }
}
