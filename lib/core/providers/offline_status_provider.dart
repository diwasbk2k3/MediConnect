import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';

/// Provider that tracks the current offline status
/// Returns true if app is OFFLINE, false if ONLINE
final offlineStatusProvider = StreamProvider<bool>((ref) async* {
  final networkInfo = ref.read(networkInfoProvider);

  // Initial check
  bool isOnline = await networkInfo.isConnected;
  yield !isOnline;

  // We could add continuous monitoring here in the future
  // For now, we'll rely on explicit checks in the code
});

/// Convenience provider to check if currently online
final isOnlineProvider = FutureProvider<bool>((ref) async {
  final networkInfo = ref.read(networkInfoProvider);
  return await networkInfo.isConnected;
});

/// Convenience provider to check if currently offline
final isOfflineProvider = FutureProvider<bool>((ref) async {
  final networkInfo = ref.read(networkInfoProvider);
  final isOnline = await networkInfo.isConnected;
  return !isOnline;
});

/// Get current offline status synchronously (last known value)
final offlineStatusNotifierProvider = StateNotifierProvider<OfflineStatusNotifier, bool>((ref) {
  return OfflineStatusNotifier();
});

class OfflineStatusNotifier extends StateNotifier<bool> {
  OfflineStatusNotifier() : super(false);

  /// Update the offline status
  void setOfflineStatus(bool isOffline) {
    state = isOffline;
  }

  /// Mark as online
  void markOnline() {
    state = false;
  }

  /// Mark as offline
  void markOffline() {
    state = true;
  }
}
