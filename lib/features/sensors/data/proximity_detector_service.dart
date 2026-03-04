import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityDetectorService {
  final StreamController<bool> _proximityController =
      StreamController<bool>.broadcast();

  StreamSubscription<dynamic>? _subscription;

  Stream<bool> get proximityStream => _proximityController.stream;

  void start() {
    _subscription = ProximitySensor.events.listen((event) {
      final bool isNear = event > 0;
      _proximityController.add(isNear);
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stop();
    _proximityController.close();
  }
}
