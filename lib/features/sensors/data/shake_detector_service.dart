import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectorService {
  /// Shake threshold - much higher now to require actual forceful shaking
  /// Typical phone movement: 5-15 m/s², Light shake: 20-30 m/s², Heavy shake: 40+ m/s²
  static const double shakeThreshold = 50.0; // Requires very forceful shake
  static const int requiredShakes = 3;
  
  /// Time window to count multiple shakes as one session
  static const Duration shakeInterval = Duration(milliseconds: 1500);
  
  /// Debounce duration - prevents counting multiple peaks of same shake as separate shakes
  static const Duration shakeDebounce = Duration(milliseconds: 400);

  StreamSubscription<AccelerometerEvent>? _subscription;
  int _shakeCount = 0;
  DateTime? _lastShakeTime;
  DateTime? _lastDetectedShakeTime; // For debouncing
  final _shakeController = StreamController<int>.broadcast();

  Stream<int> get shakeCountStream => _shakeController.stream;

  void start() {
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      _detectShake(event);
    });
  }

  void _detectShake(AccelerometerEvent event) {
    double acceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    // Detect shake (acceleration magnitude > threshold)
    if (acceleration > shakeThreshold) {
      DateTime now = DateTime.now();
      
      // Debounce: ignore if we detected a shake less than 400ms ago
      // This prevents counting multiple peaks from one physical shake gesture
      if (_lastDetectedShakeTime != null &&
          now.difference(_lastDetectedShakeTime!) < shakeDebounce) {
        return; // Ignore this peak, it's part of the same shake
      }

      // Reset shake count if more than the interval has passed
      if (_lastShakeTime != null &&
          now.difference(_lastShakeTime!) > shakeInterval) {
        _shakeCount = 0;
      }

      _shakeCount++;
      _lastShakeTime = now;
      _lastDetectedShakeTime = now; // Record when we detected this shake
      _shakeController.add(_shakeCount);

      // Auto-reset after reaching required shakes
      if (_shakeCount >= requiredShakes) {
        Future.delayed(const Duration(seconds: 3), () {
          resetShakeCount();
        });
      }
    }
  }

  int getShakeCount() => _shakeCount;

  void resetShakeCount() {
    if (_shakeCount >= requiredShakes) {
      _shakeCount = 0;
      _lastShakeTime = null;
      _lastDetectedShakeTime = null;
    }
  }

  void stop() {
    _subscription?.cancel();
  }

  void dispose() {
    stop();
    _shakeController.close();
  }
}

