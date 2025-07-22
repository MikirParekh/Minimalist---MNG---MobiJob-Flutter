part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}


final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginRespModel loginRespModel;
  const LoginSuccess({required this.loginRespModel});

  @override
  List<Object> get props => [loginRespModel];
}

final class LoginError extends LoginState {
  final String error;
  const LoginError({required this.error});

  @override
  List<Object> get props => [error];
}
