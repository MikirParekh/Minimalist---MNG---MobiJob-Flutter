part of 'count_bloc.dart';

sealed class CountEvent extends Equatable {
  const CountEvent();
}

final class FetchCount extends CountEvent{
  @override
  List<Object?> get props => [];

}