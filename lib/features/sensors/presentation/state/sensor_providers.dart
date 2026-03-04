import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/proximity_detector_service.dart';
import '../../data/shake_detector_service.dart';

final shakeDetectorServiceProvider =
    Provider((ref) => ShakeDetectorService());

final proximityDetectorServiceProvider =
  Provider((ref) => ProximityDetectorService());

final shakeCountProvider = StreamProvider<int>((ref) {
  final service = ref.watch(shakeDetectorServiceProvider);
  service.start();
  ref.onDispose(() => service.dispose());
  return service.shakeCountStream;
});

final proximityNearProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(proximityDetectorServiceProvider);
  service.start();
  ref.onDispose(() => service.dispose());
  return service.proximityStream;
});
