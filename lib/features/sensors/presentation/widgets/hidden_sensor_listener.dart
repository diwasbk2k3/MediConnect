import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/utils/snackbar_utils.dart';
import '../state/sensor_providers.dart';

class HiddenSensorListener extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback onShakeLogout;

  const HiddenSensorListener({
    super.key,
    required this.child,
    required this.onShakeLogout,
  });

  @override
  ConsumerState<HiddenSensorListener> createState() =>
      _HiddenSensorListenerState();
}

class _HiddenSensorListenerState extends ConsumerState<HiddenSensorListener> {
  bool _logoutDialogShown = false;
  DateTime? _lastProximityWarningAt;

  static const Duration _proximityToastCooldown = Duration(seconds: 6);

  @override
  Widget build(BuildContext context) {
    // Listen to shake detector
    ref.listen<AsyncValue<int>>(shakeCountProvider, (previous, shakeCount) {
      shakeCount.whenData((count) {
        if (count >= 3 && !_logoutDialogShown) {
          _logoutDialogShown = true;
          _showLogoutDialog(context);
        }
      });
    });

    // Listen to proximity sensor and warn when face/object is too close
    ref.listen<AsyncValue<bool>>(proximityNearProvider, (previous, proximity) {
      proximity.whenData((isNear) {
        if (!isNear || !mounted) {
          return;
        }

        final now = DateTime.now();
        if (_lastProximityWarningAt != null &&
            now.difference(_lastProximityWarningAt!) < _proximityToastCooldown) {
          return;
        }

        _lastProximityWarningAt = now;
        SnackbarUtils.showWarning(
          context,
          'Phone is too close to your face. Please keep a safe distance.',
        );
      });
    });

    return widget.child;
  }

  void _showLogoutDialog(BuildContext context) {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.4),
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient background
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.vibration,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Shake Detected',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'OpenSans Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Security Alert',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                            fontFamily: 'OpenSans Regular',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You have shaken your phone 3 times. This action triggers a secure logout for your protection.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                            height: 1.5,
                            fontFamily: 'OpenSans Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logout Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onShakeLogout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'OpenSans Regular',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Cancel Button
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _logoutDialogShown = false;
                            ref.read(shakeDetectorServiceProvider).resetShakeCount();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                              fontFamily: 'OpenSans Regular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
