class SensorEvent {
  final int shakeCount;

  SensorEvent({
    required this.shakeCount,
  });

  SensorEvent copyWith({
    int? shakeCount,
  }) {
    return SensorEvent(
      shakeCount: shakeCount ?? this.shakeCount,
    );
  }
}
