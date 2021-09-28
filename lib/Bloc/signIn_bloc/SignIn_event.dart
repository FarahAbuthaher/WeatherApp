part of 'SignIn_bloc.dart';


abstract class SigninEvent extends Equatable {
  const SigninEvent();
  @override
  List<Object> get props => [];
}

class SignInPressed extends SigninEvent {
  String email;
  String password;
  SignInPressed({required this.email, required this.password});
}

