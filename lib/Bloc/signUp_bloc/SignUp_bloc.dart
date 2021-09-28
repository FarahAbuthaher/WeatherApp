import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_app_task/Repository/repositories.dart';

part 'SignUp_event.dart';

part 'SignUp_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository userRepository;

  RegisterBloc({required this.userRepository}) : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is SignUpPressed) {
      yield RegisterLoading();

      try {
        var user = await userRepository.signUp(event.email, event.password,
            event.firstName, event.lastName, event.phone);
        yield RegisterSucceed(user: user);
      } catch (e) {
        yield RegisterFailed(message: e.toString());
      }
    }

    if (event is UpdateInfoPressed) {
      yield RegisterLoading();

      try {
        var user = await userRepository.Updateinfo(event.email, event.password,
            event.firstName, event.lastName, event.phone);
        yield RegisterSucceed(user: user);
      } catch (e) {
        yield RegisterFailed(message: e.toString());
      }
    }
  }
}
