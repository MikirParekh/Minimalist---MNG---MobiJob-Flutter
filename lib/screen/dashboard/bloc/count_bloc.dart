import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/screen/dashboard/model/count_model.dart';
import 'package:minimalist/screen/dashboard/model/get_status_model.dart';
import 'package:minimalist/screen/dashboard/repo/dashboard_repo.dart';
import 'package:minimalist/screen/logout/logout.dart';

part 'count_event.dart';
part 'count_state.dart';

class CountBloc extends Bloc<CountEvent, CountState> {
  DashboardRepository dashboardRepository = DashboardRepository();
  CountBloc() : super(CountInitial()) {
    on<FetchCount>((event, emit) async {
      try {
        emit(CountLoading());
        final getStatus = await dashboardRepository.getStatus();
        if (getStatus.data?.status == 1) {
          final count = await dashboardRepository.getCount();
          if (count.completed == true && getStatus.completed == true) {
            emit(CountSuccess(countModel: count, getStatusModel: getStatus));
          } else {
            emit(CountError(
              error: count.message ?? '',
            ));
          }
        } else {
          emit(CountNotPermitted(getStatusModel: getStatus));
        }
      } catch (e) {
        emit(CountError(
          error: e.toString(),
        ));
      }
    });
  }
}
