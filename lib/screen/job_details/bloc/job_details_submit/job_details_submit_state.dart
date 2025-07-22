part of 'job_details_submit_bloc.dart';

abstract class JobDetailsSubmitState extends Equatable {
  const JobDetailsSubmitState();
  @override
  List<Object> get props => [];
}

class JobDetailsSubmitInitial extends JobDetailsSubmitState {}


class GetJobDetailSubmitLoading extends JobDetailsSubmitState {}

class GetJobDetailSubmitLoaded extends JobDetailsSubmitState {
  const GetJobDetailSubmitLoaded({required this.responseModel});
  final ResponseModel responseModel;
  @override
  List<Object> get props => [responseModel];
}

class GetJobDetailSubmitError extends JobDetailsSubmitState {
  const GetJobDetailSubmitError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
