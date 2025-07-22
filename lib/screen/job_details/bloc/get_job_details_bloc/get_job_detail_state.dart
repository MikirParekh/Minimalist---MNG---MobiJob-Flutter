part of 'get_job_detail_bloc.dart';

abstract class GetJobDetailState extends Equatable {
  const GetJobDetailState();
  @override
  List<Object> get props => [];
}

class GetJobDetailInitial extends GetJobDetailState {}

class GetJobDetailLoading extends GetJobDetailState {}

class GetJobDetailLoaded extends GetJobDetailState {
  const GetJobDetailLoaded({required this.job});
  final JobModel job;
  @override
  List<Object> get props => [job];
}

class GetJobDetailError extends GetJobDetailState {
  const GetJobDetailError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
