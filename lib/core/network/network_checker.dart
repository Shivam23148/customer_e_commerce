/* import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:customer_e_commerce/core/router/app_router.dart';

class NetworkService {
  static bool isConnected = true;
  static final StreamController<bool> _networkStatusController =
      StreamController.broadcast();
  static void startListening(BuildContext context) {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      isConnected = results.any((result) => result != ConnectivityResult.none);
      if (!isConnected) {
        GoRouter.of(context).go(MyRoutes.networkerrorRoute);
      } else {
        if (RoutesObserver.lastvisitedRoute != null) {
          GoRouter.of(context).go(RoutesObserver.lastvisitedRoute!);
        }
      }
    });
  }
}
 */

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkChecker {
  final Connectivity _connectivity = Connectivity();
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

class NetworkProvider with ChangeNotifier {
  final NetworkChecker _networkChecker = NetworkChecker();
  bool _isConnected = true;
  bool get isConnected => _isConnected;
  NetworkProvider() {
    _init();
  }
  void _init() async {
    _networkChecker.connectivityStream
        .listen((List<ConnectivityResult> results) {
      _isConnected = results.any((result) => result != ConnectivityResult.none);
      notifyListeners();
    });
  }
}
