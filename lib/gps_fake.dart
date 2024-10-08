import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsFake extends StatefulWidget {
  const GpsFake({super.key});

  @override
  State<GpsFake> createState() => _GpsFakeState();
}

class _GpsFakeState extends State<GpsFake> {
  String gpsStatus = "Verificando...";

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    try {
      // Pedimos permisos para acceder a la ubicación
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          gpsStatus = "El GPS está desactivado";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            gpsStatus = "Permiso de GPS denegado";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          gpsStatus = "Permiso de GPS denegado permanentemente";
        });
        return;
      }

      // Obtenemos la posición
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Verificamos si es ubicación simulada
      bool isMock = position.isMocked;
      setState(() {
        gpsStatus = isMock ? "Ubicación simulada" : "Ubicación real";
      });
    } catch (e) {
      setState(() {
        gpsStatus = "Error al obtener la ubicación";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verificador de GPS"),
      ),
      body: Center(
        child: Text(
          gpsStatus,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
