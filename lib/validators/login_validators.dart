import 'dart:async';

class LoginValidators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains("@"))
        sink.add(email);
      else
        sink.addError("E-mail inválido!");
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.isEmpty)
        sink.addError("A senha não pode ser vazia!");
      else
        sink.add(password);
    }
  );
}