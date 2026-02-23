import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediconnect/features/appointment/presentation/state/appointment_state.dart';

class AppointmentListScreen extends ConsumerStatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  ConsumerState<AppointmentListScreen> createState() =>
      _AppointmentListScreenState();
}

class _AppointmentListScreenState extends ConsumerState<AppointmentListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref
          .read(appointmentViewModelProvider.notifier)
          .getAppointmentsByStatus('not-visited');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: const Text(
          'My Appointments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            if (index == 0) {
              appointmentViewModel.getAppointmentsByStatus('not-visited');
            } else if (index == 1) {
              appointmentViewModel.getAppointmentsByStatus('visited');
            } else {
              appointmentViewModel.getAppointmentsByStatus('cancelled');
            }
          },
          indicatorColor: const Color(0xFF4FA3F5),
          labelColor: const Color(0xFF4FA3F5),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Scheduled'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Scheduled Appointments Tab
          _buildAppointmentList(
            appointmentState,
            appointmentViewModel,
            status: 'not-visited',
          ),
          // Completed Appointments Tab
          _buildAppointmentList(
            appointmentState,
            appointmentViewModel,
            status: 'visited',
          ),
          // Cancelled Appointments Tab
          _buildAppointmentList(
            appointmentState,
            appointmentViewModel,
            status: 'cancelled',
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(
    AppointmentState state,
    AppointmentViewModel viewModel, {
    required String status,
  }) {
    if (state.status == AppointmentStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4FA3F5),
        ),
      );
    }

    if (state.status == AppointmentStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Failed to load appointments',
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
                  viewModel.getAppointmentsByStatus(status);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FA3F5),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.appointments.isEmpty) {
      final emptyText = status == 'not-visited'
          ? 'No Scheduled Appointments'
          : status == 'visited'
              ? 'No Completed Appointments'
              : 'No Cancelled Appointments';
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              emptyText,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.appointments.length,
      itemBuilder: (context, index) {
        final appointment = state.appointments[index];
        final isCompleted = status == 'visited';
        final isCancelled = status == 'cancelled';
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCancelled
                  ? Colors.red.shade200
                  : Colors.grey.shade200,
            ),
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
                // Header with Hospital Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.hospitalName ?? 'Hospital',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4FA3F5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment.department ?? 'Department',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isCancelled
                            ? Colors.red.shade50
                            : isCompleted
                                ? Colors.green.shade50
                                : Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCancelled
                              ? Colors.red.shade200
                              : isCompleted
                                  ? Colors.green.shade200
                                  : Colors.amber.shade200,
                        ),
                      ),
                      child: Text(
                        appointment.appointmentType ?? 'New',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isCancelled
                              ? Colors.red.shade700
                              : isCompleted
                                  ? Colors.green.shade700
                                  : Colors.amber.shade700,
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
                        size: 16, color: Colors.grey.shade600),
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
                        size: 16, color: Colors.grey.shade600),
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
                        size: 16, color: Colors.grey.shade600),
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
                // Show Cancellation Reason if Cancelled
                if (isCancelled && appointment.cancellationReason != null)
                  ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cancellation Reason',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment.cancellationReason ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                const SizedBox(height: 16),

                // Action Buttons
                if (!isCompleted && !isCancelled)
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
                        side: BorderSide(color: Colors.red.shade200),
                      ),
                      child: const Text('Cancel Appointment'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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
