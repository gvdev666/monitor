import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'characteristics.dart';
class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];
  bool _scanning = false;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
  }

  void _startScan() async {
    setState(() {
      devices.clear();
      _scanning = true;
    });

    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!devices.contains(r.device)) {
          setState(() {
            devices.add(r.device);
          });
        }
      }
    });

    flutterBlue.stopScan();
    setState(() {
      _scanning = false;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
    });

    await device.connect();

    setState(() {
      _isConnecting = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicesScreen(device: device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _startScan();
            },
            child: Text('Scan for devices'),
          ),
          SizedBox(height: 20),
          _scanning
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return ListTile(
                        title: Text(device.name.isNotEmpty
                            ? device.name
                            : 'Unknown Device'),
                        subtitle: Text(device.id.toString()),
                        onTap: () {
                          _connectToDevice(device);
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
