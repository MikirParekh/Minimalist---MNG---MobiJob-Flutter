part of 'job_details_submit_bloc.dart';

abstract class JobDetailsSubmitEvent extends Equatable {
  const JobDetailsSubmitEvent();
}

class SubmitJobDetailsEvent extends JobDetailsSubmitEvent {
  final String jonNo;
  final String status;
  final String customerSignature;
  final String driverSignature;
  final String customerLatLong;
  final String driverLatLong;
  final String remark;
  final String pickupTime;
  // final bool withSignature;
  final String raStatus;
  const SubmitJobDetailsEvent(
      {required this.jonNo,
      required this.status,
      required this.customerSignature,
      required this.driverSignature,
      required this.customerLatLong,
      required this.driverLatLong,
      required this.remark,
      required this.pickupTime,
      // required this.withSignature,
      required this.raStatus});

  @override
  List<Object?> get props => [
        jonNo,
        status,
        customerSignature,
        driverSignature,
        customerLatLong,
        driverLatLong,
        remark,
        pickupTime,
        // withSignature,
        raStatus
      ];
}
