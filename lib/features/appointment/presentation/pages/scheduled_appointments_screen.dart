import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediconnect/features/appointment/presentation/state/appointment_state.dart';

class ScheduledAppointmentsScreen extends ConsumerStatefulWidget {
  const ScheduledAppointmentsScreen({super.key});

  @override
  ConsumerState<ScheduledAppointmentsScreen> createState() =>
      _ScheduledAppointmentsScreenState();
}

class _ScheduledAppointmentsScreenState
    extends ConsumerState<ScheduledAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(appointmentViewModelProvider.notifier)
          .getAppointmentsByStatus('not-visited');
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentViewModelProvider);
    final appointmentViewModel = ref.read(appointmentViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scheduled Appointments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: appointmentState.status == AppointmentStatus.loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4FA3F5),
              ),
            )
          : appointmentState.status == AppointmentStatus.error
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.red.shade400),
                        const SizedBox(height: 16),
                        Text(
                          appointmentState.errorMessage ??
                              'Failed to load appointments',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            appointmentViewModel
                                .getAppointmentsByStatus('not-visited');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FA3F5),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : appointmentState.appointments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today,
                              size: 48,
                              color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No Scheduled Appointments',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Book an appointment to get started',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: appointmentState.appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointmentState.appointments[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with status
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      appointment.department ?? 'Department',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.amber.shade200,
                                        ),
                                      ),
                                      child: Text(
                                        appointment.appointmentType ?? 'New',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Date and Time
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(
                                      appointment.appointmentDate ?? '--',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.access_time,
                                        size: 16,
                                        color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(
                                      appointment.appointmentTime ?? '--',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Amount
                                Row(
                                  children: [
                                    Icon(Icons.currency_rupee,
                                        size: 16,
                                        color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Rs. ${appointment.paymentAmount?.toStringAsFixed(0) ?? '0'}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Cancel Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showCancelReason(
                                        context,
                                        appointment.appointmentId ?? '',
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade50,
                                      foregroundColor: Colors.red.shade700,
                                      side: BorderSide(
                                        color: Colors.red.shade200,
                                      ),
                                    ),
                                    child: const Text('Cancel Appointment'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  void _showCancelReason(BuildContext context, String appointmentId) {
    final reasonController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cancel Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please provide a reason for cancellation:',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter cancellation reason...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (reasonController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('Please provide a reason'),
                          ),
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      await ref
                          .read(appointmentViewModelProvider.notifier)
                          .cancelAppointment(
                            appointmentId: appointmentId,
                            cancellationReason: reasonController.text.trim(),
                          );

                      Navigator.pop(dialogContext);

                      final state =
                          ref.read(appointmentViewModelProvider);
                      if (state.status == AppointmentStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.successMessage ??
                                  'Appointment cancelled',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Refresh list
                        Future.delayed(const Duration(seconds: 1), () {
                          ref
                              .read(appointmentViewModelProvider.notifier)
                              .getAppointmentsByStatus('not-visited');
                        });
                      } else if (state.status ==
                          AppointmentStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.errorMessage ??
                                  'Failed to cancel',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Confirm Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
