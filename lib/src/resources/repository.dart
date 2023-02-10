import './api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();

  fetchVehiclesLastPackets(int customerId) {
    return apiProvider.fetchVehiclesLastPackets(customerId);
  }

  checkEmailAndPassword(String email, String password) {
    return apiProvider.checkEmailAndPassword(email, password);
  }
}
