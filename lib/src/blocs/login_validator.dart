import '../resources/repository.dart';

class LoginValidator {
  final _repository = Repository();

  validator(email, password) async {
    String e = '';
    String p = '';

    if (email.hasValue) {
      if (email.value == '') {
        email.sink.addError('Email cannot be empty!');
      } else {
        e = email.value;
      }
    } else {
      email.sink.addError('Email cannot be empty!');
    }

    if (password.hasValue) {
      if (password.value == '') {
        password.sink.addError('Password cannot be empty!');
      } else {
        p = password.value;
      }
    } else {
      password.sink.addError('Password cannot be empty!');
    }

    if (e.isNotEmpty && p.isNotEmpty) {
      return _repository.checkEmailAndPassword(e, p);
    }
  }
}
