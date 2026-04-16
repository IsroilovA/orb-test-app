part of 'home_bloc.dart';

final class HomeState extends Equatable {
  const HomeState({this.overview, this.isLoading = false, this.error});

  final HomeOverview? overview;
  final bool isLoading;
  final Object? error;

  HomeState copyWith({HomeOverview? overview, bool? isLoading, Object? error, bool clearError = false}) => HomeState(
    overview: overview ?? this.overview,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
  );

  @override
  List<Object?> get props => <Object?>[overview, isLoading, error];
}
