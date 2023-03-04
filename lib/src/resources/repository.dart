import './api_provider.dart';
import './db_provider.dart';

class Repository {
  final apiProvider = ApiProvider();
  final dbProvider = DbProvider();

  addCustomer(int customerId, String customerName, String token) async {
    await dbProvider.addCustomer(customerId, customerName, token);
    await apiProvider.addCustomerToken(customerId, token);
  }

  fetchCustomer() {
    return dbProvider.fetchCustomer();
  }

  clearCustomer(int customerId, String token) async {
    await dbProvider.clearCustomer();
    await apiProvider.removeCustomerToken(customerId, token);
  }

  fetchVehiclesLastPackets(int customerId) {
    return apiProvider.fetchVehiclesLastPackets(customerId);
  }

  fetchTrack(String query) {
    return apiProvider.fetchTrack(query);
  }

  fetchVehicles(int customerId) {
    return apiProvider.fetchVehicles(customerId);
  }

  fetchStats(int customerId) {
    return apiProvider.fetchStats(customerId);
  }

  followVehicle(int vehicleId) {
    return apiProvider.followVehicle(vehicleId);
  }

  checkEmailAndPassword(String email, String password) {
    return apiProvider.checkEmailAndPassword(email, password);
  }
}
