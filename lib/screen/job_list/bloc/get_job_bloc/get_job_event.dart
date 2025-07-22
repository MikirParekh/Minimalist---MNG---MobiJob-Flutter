part of 'get_job_bloc.dart';

abstract class GetJobEvent extends Equatable {
  const GetJobEvent();
}

class FetchJobEvent extends GetJobEvent{
  final int status;
  final String fromDate;
  final String toDate;
  const FetchJobEvent({required this.status,required this.fromDate,required this.toDate});
  @override
  List<Object?> get props => [status,fromDate,toDate];

}