part of 'count_bloc.dart';

sealed class CountState extends Equatable {
  const CountState();
  @override
  List<Object> get props => [];
}

final class CountInitial extends CountState {}

final class CountLoading extends CountState {}

final class CountSuccess extends CountState {
  final CountModel countModel;
  const CountSuccess({required this.countModel});
  @override
  List<Object> get props => [countModel];
}

final class CountError extends CountState {
  final String error;
  const CountError({required this.error});
  @override
  List<Object> get props => [error];
}
