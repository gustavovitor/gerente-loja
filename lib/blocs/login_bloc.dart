import 'dart:async';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenteloja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidators {
  LoginBloc() {
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  StreamSubscription _streamSubscription;

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);

  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);

  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => Observable.combineLatest2(outEmail, outPassword, (email, password) => true);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  void submit() {
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password).catchError((e) {
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return await Firestore.instance.collection("admins").document(user.uid).get().then((document) {
      return document.data != null;
    }).catchError((e) => false);
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();

    _streamSubscription.cancel();
  }
}
