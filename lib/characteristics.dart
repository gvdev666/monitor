import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ServicesScreen extends StatefulWidget {
  final BluetoothDevice device;

  const ServicesScreen(
      {Key key = const Key('services_screen'), required this.device})
      : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<BluetoothService> services = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _discoverServices();
  }

  void _discoverServices() async {
    services = await widget.device.discoverServices();
  }
  
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ListTile(
                  title: Text('Service: ${service.uuid}'),
                  subtitle: Text(
                      'Characteristics: ${service.characteristics.length}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CharacteristicsScreen(key: ValueKey(service.uuid), service: service,),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}


class CharacteristicsScreen extends StatefulWidget {
   final BluetoothService service;

  CharacteristicsScreen({required Key key, required this.service}) : super(key: key);


  @override
  _CharacteristicsScreenState createState() => _CharacteristicsScreenState();
}

class _CharacteristicsScreenState extends State<CharacteristicsScreen> {
  List<BluetoothCharacteristic> characteristics = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _discoverCharacteristics();
  }

  void _discoverCharacteristics() async {
    try {
      List<BluetoothCharacteristic> c = await widget.service.characteristics;
      setState(() {
        characteristics = c;
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characteristics'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: characteristics.length,
              itemBuilder: (context, index) {
                final characteristic = characteristics[index];
                return ListTile(
                  title: Text('Characteristic: ${characteristic.uuid}'),
                  subtitle: Text('Properties: ${characteristic.properties}'),
                );
              },
            ),
    );
  }
}
