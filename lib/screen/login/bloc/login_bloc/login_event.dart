part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username,password;
  const LoginButtonPressed({required this.username, required this.password,});

  @override
  List<Object> get props => [username,password];
}
