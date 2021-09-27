part of 'SignIn_bloc.dart';

abstract class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends SigninState {}

class SigninLoading extends SigninState {}

class SigninSucceed extends SigninState {
  User? user;
  SigninSucceed({required this.user});
}

class SigninFailed extends SigninState {
  String message;
  SigninFailed({required this.message});
}