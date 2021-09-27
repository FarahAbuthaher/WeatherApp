part of 'SignUp_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class SignUpPressed extends RegisterEvent {
  String email, password, firstName, lastName, phone;
  SignUpPressed({required this.email, required this.password, required this.firstName, required this.lastName, required this.phone});
}

class UpdateInfoPressed extends RegisterEvent {
  String? email, password;
  String firstName, lastName, phone;
  UpdateInfoPressed({this.email, this.password, required this.firstName, required this.lastName, required this.phone});
}