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
  final GetStatusModel getStatusModel;
  const CountSuccess({required this.countModel, required this.getStatusModel});
  @override
  List<Object> get props => [countModel, getStatusModel];
}

final class CountError extends CountState {
  final String error;
  const CountError({required this.error});
  @override
  List<Object> get props => [error];
}

final class CountNotPermitted extends CountState {
  final GetStatusModel getStatusModel;
  const CountNotPermitted({required this.getStatusModel});

  @override
  List<Object> get props => [getStatusModel];
}
