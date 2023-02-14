import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

class AppBloc {
  final _repository = Repository();
  final _vehiclesLastPackets = BehaviorSubject();
  final _vehicleTrack = BehaviorSubject();
  final _vehicles = BehaviorSubject();

  get vehiclesLastPackets => _vehiclesLastPackets.stream;
  get vehicleTrack => _vehicleTrack.stream;
  get vehicles => _vehicles.stream;

  fetchVehiclesLastPackets(int customerId) async {
    final lastPackets = await _repository.fetchVehiclesLastPackets(customerId);
    _vehiclesLastPackets.sink.add(lastPackets);
  }

  fetchTrack(int vehicleId, String tableName) async {
    final track = await _repository.fetchTrack(vehicleId, tableName);
    _vehicleTrack.sink.add(track);
  }

  fetchVehicles(int customerId) async {
    final vehicles = await _repository.fetchVehicles(customerId);
    _vehicles.sink.add(vehicles);
  }
}
