import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

class AppBloc {
  final _repository = Repository();
  final _vehiclesLastPackets = BehaviorSubject();
  final _vehicleTrack = BehaviorSubject();
  final _vehicles = BehaviorSubject();
  final _follow = BehaviorSubject();
  final _stats = BehaviorSubject();

  get vehiclesLastPackets => _vehiclesLastPackets.stream;
  get vehicleTrack => _vehicleTrack.stream;
  get vehicles => _vehicles.stream;
  get follow => _follow.stream;
  get stats => _stats.stream;

  fetchVehiclesLastPackets(int customerId) async {
    final lastPackets = await _repository.fetchVehiclesLastPackets(customerId);
    _vehiclesLastPackets.sink.add(lastPackets);
  }

  fetchTrack(String query) async {
    final track = await _repository.fetchTrack(query);
    _vehicleTrack.sink.add(track);
  }

  fetchVehicles(int customerId) async {
    final vehicles = await _repository.fetchVehicles(customerId);
    _vehicles.sink.add(vehicles);
  }

  fetchStats(int customerId) async {
    final vehicles = await _repository.fetchStats(customerId);
    _stats.sink.add(vehicles);
  }

  followVehicle(int vehicleId) async {
    final packet = await _repository.followVehicle(vehicleId);
    _follow.sink.add(packet);
  }
}
