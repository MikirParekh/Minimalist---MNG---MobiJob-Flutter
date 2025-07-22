part of 'get_job_bloc.dart';

abstract class GetJobState extends Equatable {
  const GetJobState();
  @override
  List<Object> get props => [];
}

class GetJobInitial extends GetJobState {}

class GetJobLoading extends GetJobState {}

class GetJobLoaded extends GetJobState {
  const GetJobLoaded({required this.list});
  final List<JobModel> list;
  @override
  List<Object> get props => [list];
}

class GetJobError extends GetJobState {
  const GetJobError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
