import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AppBluetoothService {

  AppBluetoothService._privateConstructor();

  static final AppBluetoothService instance = AppBluetoothService._privateConstructor();
  Future<void> startScan() async {
    if (!await _handlerBluetoothPermissions()) {
      throw Exception('Bluetooth permissions not granted');
    }

    if (await _bluetoothIsOnStream.firstWhere((isOn) => isOn) == false) {
      throw Exception('Bluetooth is turned off');
    }

    if (FlutterBluePlus.isScanningNow) return;


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

  Future<bool> _handlerBluetoothPermissions() async {
    var statusScan = await Permission.bluetoothScan.status;
    var statusConnect = await Permission.bluetoothConnect.status;
    var statusLocation = await Permission.location.status;

    if (statusScan.isDenied) await Permission.bluetoothScan.request();
    if (statusConnect.isDenied) await Permission.bluetoothConnect.request();
    if (statusLocation.isDenied) await Permission.location.request();

    return await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted;
  }

  Stream<bool> get _bluetoothIsOnStream => FlutterBluePlus.adapterState
      .map((state) => state == BluetoothAdapterState.on);

}
