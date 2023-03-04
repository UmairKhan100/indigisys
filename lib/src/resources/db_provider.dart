// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DbProvider {
  late Database db;

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'customer.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (newDb, version) async {
        await newDb.execute('''
        CREATE TABLE Notification
          (
            customerId INTEGER PRIMARY_KEY,
            alarmName TEXT,
            gpsTime TEXT,
            vehicleNumber TEXT
          )
      ''');

        await newDb.execute('''
        CREATE TABLE Customer
          (
            id INTEGER PRIMARY_KEY,
            name TEXT,
            token TEXT
          )
      ''');
      },
    );
  }

  Future fetchCustomer() async {
    await init();
    final maps = await db.query(
      'Customer',
      columns: null,
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }

    return {'id': 0};
  }

  Future<int> addCustomer(int customerId, String customerName, String token) {
    return db.insert(
      'Customer',
      {
        'id': customerId,
        'name': customerName,
        'token': token,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> clearCustomer() {
    return db.delete('Customer');
  }

  Future fetchNotifications(int customerId) async {
    await init();
    final maps = await db.query(
      'Notification',
      columns: null,
      where: 'customerId = ?',
      whereArgs: [customerId],
      distinct: true,
      orderBy: 'gpsTime DESC',
    );

    return maps;
  }

  Future<int> addNotification(int customerId, String alarmName, String gpsTime,
      String vehicleNumber) async {
    await init();
    return db.insert(
      'Notification',
      {
        'customerId': customerId,
        'alarmName': alarmName,
        'gpsTime': gpsTime,
        'vehicleNumber': vehicleNumber
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
