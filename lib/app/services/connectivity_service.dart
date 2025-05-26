import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:takaful/utils/catcher_util.dart';

class ConnectivityService extends GetxService {
  final connectionStatus = Rx<ConnectivityResult>(ConnectivityResult.none);
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<ConnectivityService> init() async {
    await initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    return this;
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus.value = result;
    await watchConnectionStatus(result);
  }

  watchConnectionStatus(status) {
    Get.closeAllSnackbars();
    if (status == ConnectivityResult.none) {
      Get.rawSnackbar(
        title: "You're offline!",
        message: "Please connect to the internet.",
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.signal_cellular_connected_no_internet_4_bar_sharp),
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(minutes: 1),
        margin: const EdgeInsets.all(12),
        borderRadius: 5,
      );
    }
  }
}
