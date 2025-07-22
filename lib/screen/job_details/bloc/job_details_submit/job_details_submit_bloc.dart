import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimalist/model/resp_model.dart';
import 'package:minimalist/screen/job_list/repo/job_repo.dart';

part 'job_details_submit_event.dart';
part 'job_details_submit_state.dart';

class JobDetailsSubmitBloc
    extends Bloc<JobDetailsSubmitEvent, JobDetailsSubmitState> {
  JobRepository jobRepository = JobRepository();
  JobDetailsSubmitBloc() : super(JobDetailsSubmitInitial()) {
    on<SubmitJobDetailsEvent>((event, emit) async {
      emit(GetJobDetailSubmitLoading());
      try {
        var result = await jobRepository.jobDetailsStatusChange(
            event.jonNo,
            event.status,
            event.customerSignature,
            event.driverSignature,
            event.customerLatLong,
            event.driverLatLong,
            event.remark,
            event.pickupTime,
            // event.withSignature,
            event.raStatus);
        if (result.status == true) {
          emit(GetJobDetailSubmitLoaded(responseModel: result));
        } else {
          emit(GetJobDetailSubmitError(
              error: result.message ?? "Operation Failed"));
        }
      } catch (e) {
        emit(GetJobDetailSubmitError(error: e.toString()));
      }
    });
  }
}
