import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

class AppBloc {
  final _repository = Repository();
  final _vehiclesLastPackets = BehaviorSubject();

  get vehiclesLastPackets => _vehiclesLastPackets.stream;

  fetchVehiclesLastPackets(int customerId) async {
    final lastPackets = await _repository.fetchVehiclesLastPackets(customerId);
    _vehiclesLastPackets.sink.add(lastPackets);
  }
}
