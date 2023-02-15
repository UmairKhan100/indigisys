import './api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();

  fetchVehiclesLastPackets(int customerId) {
    return apiProvider.fetchVehiclesLastPackets(customerId);
  }

  fetchTrack(int vehicleId, String tableName) {
    return apiProvider.fetchTrack(vehicleId, tableName);
  }

  fetchVehicles(int customerId) {
    return apiProvider.fetchVehicles(customerId);
  }

  followVehicle(int vehicleId) {
    return apiProvider.followVehicle(vehicleId);
  }

  checkEmailAndPassword(String email, String password) {
    return apiProvider.checkEmailAndPassword(email, password);
  }
}
