import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../repositories.dart';

part 'SignIn_event.dart';

part 'SignIn_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  UserRepository? userRepository;

  SigninBloc({@required this.userRepository}) : super(SigninInitial());

  @override
  Stream<SigninState> mapEventToState(
    SigninEvent event,
  ) async* {
    if (event is SignInPressed) {
      yield SigninLoading();

      try {
        var user = await userRepository!.signIn(event.email, event.password);
        if (user != null) {
          Fluttertoast.showToast(msg: 'Signed in successfully');
          yield SigninSucceed(user: user);
        } else Fluttertoast.showToast(msg:  'incorrect user or password');
      } catch (e) {
        yield SigninFailed(message: e.toString());
      }
    }
  }
}
