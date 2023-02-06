import 'package:http/http.dart' show post;

class LoginValidator {
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
      final response = await post(
        Uri.http(
          '103.121.120.8:6000',
          '/api/v2/login',
          {'email': e, 'password': p},
        ),
      );
      return response;
    }
  }
}
