part of 'get_job_detail_bloc.dart';

abstract class GetJobDetailEvent extends Equatable {
  const GetJobDetailEvent();
}

class FetchJobDetailEvent extends GetJobDetailEvent{
  final String jobNo;
  const FetchJobDetailEvent({required this.jobNo});

  @override
  List<Object?> get props => [jobNo];

}