part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginForm extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final String? token;
  LoginSuccess({this.token});

  @override
  List<Object?> get props => [];
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
