import 'package:rxdart/rxdart.dart';

import './login_validator.dart';

class LoginBloc with LoginValidator {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  get changeEmail => _email.sink.add;
  get changePassword => _password.sink.add;

  Stream<String> get email => _email.stream;
  Stream<String> get password => _password.stream;

  get validate => validator(_email, _password);
}
