import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimalist/screen/login/model/login_resp_model.dart';
import 'package:minimalist/screen/login/repo/login_repo.dart';
import 'package:minimalist/service/secure_storage_service.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository loginRepository = LoginRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      try{
        emit(LoginLoading());
        final user = await loginRepository.login(event.username,event.password);
        if(user.completed == true){
          emit(LoginSuccess(loginRespModel: user));
        }else{
          emit(LoginError(error: user.message ?? '',));
        }
      }catch(e){
        emit(LoginError(error: e.toString(),));
      }
    });
  }
}