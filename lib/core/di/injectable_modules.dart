import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../network/network_info.dart';

@module
abstract class InjectableModules {
  // Core dependencies
  @lazySingleton
  DatabaseHelper get databaseHelper => DatabaseHelper.instance;

  @preResolve
  Future<Database> get database async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.database;
  }

  @lazySingleton
  InternetConnectionChecker get connectionChecker => InternetConnectionChecker();

  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl(InternetConnectionChecker());

  @preResolve
  Future<SharedPreferences> get sharedPreferences async => await SharedPreferences.getInstance();
}
