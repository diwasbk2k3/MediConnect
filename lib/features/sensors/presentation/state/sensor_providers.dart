import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/shake_detector_service.dart';

final shakeDetectorServiceProvider =
    Provider((ref) => ShakeDetectorService());

final shakeCountProvider = StreamProvider<int>((ref) {
  final service = ref.watch(shakeDetectorServiceProvider);
  service.start();
  ref.onDispose(() => service.dispose());
  return service.shakeCountStream;
});


