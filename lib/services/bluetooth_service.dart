import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AppBluetoothService {

  AppBluetoothService._privateConstructor();

  static final AppBluetoothService instance = AppBluetoothService._privateConstructor();
  Future<void> startScan() {
    return FlutterBluePlus.startScan(
        timeout: null, androidUsesFineLocation: true, continuousUpdates: true);
  }

  Future<void> stopScan() => FlutterBluePlus.stopScan();

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  bool get isScanningNow => FlutterBluePlus.isScanningNow;

  Future<bool> requestPermissions() async {
    var statusScan = await Permission.bluetoothScan.request();
    var statusConnect = await Permission.bluetoothConnect.request();
    var statusLocation = await Permission.location.request();
    
    return statusScan.isGranted && statusConnect.isGranted && statusLocation.isGranted;
  }
}
