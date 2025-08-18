import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimalist/screen/job_list/model/job_model.dart';
import 'package:minimalist/screen/job_list/repo/job_repo.dart';
import 'package:minimalist/utils/util.dart';

part 'get_job_event.dart';
part 'get_job_state.dart';

class GetJobBloc extends Bloc<GetJobEvent, GetJobState> {
  JobRepository jobRepository = JobRepository();
  GetJobBloc() : super(GetJobInitial()) {
    on<FetchJobEvent>((event, emit) async {
      emit(GetJobLoading());
      try {
        var result = await jobRepository.getJob(
            event.status, event.fromDate, event.toDate);
        showLog(result.toString());
        emit(GetJobLoaded(list: result));
      } catch (e) {
        emit(GetJobError(error: e.toString()));
      }
    });
  }
}
