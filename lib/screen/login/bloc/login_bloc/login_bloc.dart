import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimalist/screen/login/model/login_resp_model.dart';
import 'package:minimalist/screen/login/repo/login_repo.dart';
import 'package:minimalist/service/secure_storage_service.dart';
import 'package:minimalist/utils/util.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository loginRepository = LoginRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      try {
        emit(LoginLoading());
        showLog("before login api call");
        final user =
            await loginRepository.login(event.username, event.password);
        showLog("after login api call. -----> $user");
        if (user.completed == true) {
          showLog("User Permission ---> ${user.data?.hasPermission}");
          if (user.data?.hasPermission == true) {
            emit(LoginSuccess(loginRespModel: user));
          } else {
            emit(LoginError(error: "You do not have permission!"));
          }
        } else {
          emit(LoginError(
            error: user.message ?? '',
          ));
        }
      } catch (e) {
        showLog("LoginButtonPressed catch  -----> $e");
        emit(LoginError(
          error: e.toString(),
        ));
      }
    });
  }
}
