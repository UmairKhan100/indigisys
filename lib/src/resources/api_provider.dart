import 'dart:convert';
import 'package:http/http.dart' show get, post;

class ApiProvider {
  fetchVehiclesLastPackets(int customerId) async {
    final response = await get(
      Uri.http(
        '103.121.120.8:7000',
        '/api/v2/last-packets',
        {'c_id': '$customerId'},
      ),
    );

    final parsedJson = json.decode(response.body.toString());
    return parsedJson;
  }

  fetchTrack(String query) async {
    final response = await get(Uri.http(
      '103.121.120.8:7000',
      '/api/v1/fetchall',
      {'query': query},
    ));

    final parsedJson = json.decode(response.body.toString());
    return parsedJson;
  }

  fetchVehicles(int customerId) async {
    final response = await get(Uri.http(
      '103.121.120.8:7000',
      '/api/v2/vehicles',
      {'c_id': '$customerId'},
    ));

    final parsedJson = json.decode(response.body.toString());
    return parsedJson;
  }

  fetchStats(int customerId) async {
    final response = await get(Uri.http(
      '103.121.120.8:7000',
      '/api/v2/stats',
      {'c_id': '$customerId'},
    ));

    final parsedJson = json.decode(response.body.toString());
    return parsedJson;
  }

  followVehicle(int vehicleId) async {
    final now = DateTime.now();
    final String tableName =
        'gps_packets_${now.year}_${now.month.toString().padLeft(2, "0")}_${now.day.toString().padLeft(2, "0")}';

    final response = await get(Uri.http(
      '103.121.120.8:7000',
      '/api/v1/fetchone',
      {
        'query':
            'SELECT * FROM $tableName WHERE v_id=$vehicleId ORDER BY gps_time DESC LIMIT 1',
      },
    ));

    final parsedJson = json.decode(response.body.toString());
    return parsedJson;
  }

  checkEmailAndPassword(String email, String password) async {
    final response = await post(
      Uri.http(
        '103.121.120.8:7000',
        '/api/v2/login',
        {'email': email, 'password': password},
      ),
    );

    final parsedJson = json.decode(response.body.toString());
    return parsedJson;
  }

  addCustomerToken(int customerId, String token) async {
    final response = await get(
      Uri.http(
        '103.121.120.8:7000',
        '/api/v2/add-fcm',
        {'c_id': '$customerId', 'token': token},
      ),
    );

    final parsedJson = json.decode(response.body.toString());
    return parsedJson;
  }

  removeCustomerToken(int customerId, String token) async {
    final response = await get(
      Uri.http(
        '103.121.120.8:7000',
        '/api/v2/remove-fcm',
        {'c_id': '$customerId', 'token': token},
      ),
    );

    final parsedJson = json.decode(response.body.toString());
    return parsedJson;
  }
}
