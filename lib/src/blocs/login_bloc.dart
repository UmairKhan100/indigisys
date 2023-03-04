import 'package:rxdart/rxdart.dart';

import './login_validator.dart';
import '../resources/repository.dart';

class LoginBloc with LoginValidator {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _customer = BehaviorSubject<Map>();

  get changeEmail => _email.sink.add;
  get changePassword => _password.sink.add;

  Stream<String> get email => _email.stream;
  Stream<String> get password => _password.stream;
  Stream get customer => _customer.stream;

  get validate => validator(_email, _password);

  addCustomer(int customerId, String customerName, String token) async {
    await _repository.addCustomer(customerId, customerName, token);
  }

  clearCustomer(int customerId, String token) {
    _repository.clearCustomer(customerId, token);
  }

  fetchCustomer() async {
    final customer = await _repository.fetchCustomer();
    _customer.sink.add(customer);
  }
}
