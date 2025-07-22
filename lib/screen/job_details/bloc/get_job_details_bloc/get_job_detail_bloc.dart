import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimalist/screen/job_list/model/job_model.dart';
import 'package:minimalist/screen/job_list/repo/job_repo.dart';

part 'get_job_detail_event.dart';
part 'get_job_detail_state.dart';

class GetJobDetailBloc extends Bloc<GetJobDetailEvent, GetJobDetailState> {
  JobRepository jobRepository = JobRepository();
  GetJobDetailBloc() : super(GetJobDetailInitial()) {
    on<FetchJobDetailEvent>((event, emit) async {
      emit(GetJobDetailLoading());
      try{
        var result = await jobRepository.getJobDetails(event.jobNo);
        emit(GetJobDetailLoaded(job: result));
      }catch(e){
        emit(GetJobDetailError(error: e.toString()));
      }
    });
  }
}
