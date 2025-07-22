import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimalist/screen/dashboard/model/count_model.dart';
import 'package:minimalist/screen/dashboard/repo/dashboard_repo.dart';

part 'count_event.dart';
part 'count_state.dart';

class CountBloc extends Bloc<CountEvent, CountState> {
  DashboardRepository dashboardRepository = DashboardRepository();
  CountBloc() : super(CountInitial()) {
    on<FetchCount>((event, emit) async {
      try{
        emit(CountLoading());
        final count = await dashboardRepository.getCount();
        if(count.completed == true){
          emit(CountSuccess(countModel: count));
        }else{
          emit(CountError(error: count.message ?? '',));
        }
      }catch(e){
        emit(CountError(error: e.toString(),));
      }
    });
  }
}
