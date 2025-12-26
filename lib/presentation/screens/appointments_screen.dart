import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mychart_fhir_app/localization/app_localizations.dart';
import 'package:mychart_fhir_app/presentation/providers/appointments_provider.dart';
import 'package:mychart_fhir_app/core/utils/rtl_utils.dart';

/// Appointments Screen
/// 
/// Displays upcoming and past appointments
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load appointments when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentsProvider>().loadAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.appointments,
          style: TextStyle(fontFamily: RtlUtils.getFontFamily(context)),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming', icon: Icon(Icons.upcoming)),
            Tab(text: 'Past', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<AppointmentsProvider>().loadAppointments();
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _AppointmentsList(isUpcoming: true),
            _AppointmentsList(isUpcoming: false),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final bool isUpcoming;

  const _AppointmentsList({required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<AppointmentsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage!,
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadAppointments(),
                  child: Text(localizations.retry),
                ),
              ],
            ),
          );
        }

        final appointments = isUpcoming
            ? provider.upcomingAppointments
            : provider.pastAppointments;

        if (appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isUpcoming ? Icons.calendar_today_outlined : Icons.history_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  isUpcoming
                      ? 'No upcoming appointments'
                      : 'No past appointments',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _AppointmentCard(appointment: appointment, isUpcoming: isUpcoming);
          },
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final dynamic appointment; // AppointmentModel
  final bool isUpcoming;

  const _AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = RtlUtils.isRtl(context);
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: isUpcoming ? Colors.blue : Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (appointment.description != null)
                        Text(
                          appointment.description!,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: RtlUtils.getFontFamily(context),
                              ),
                        ),
                      if (appointment.start != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${dateFormat.format(appointment.start!)} • ${timeFormat.format(appointment.start!)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: RtlUtils.getFontFamily(context),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (appointment.practitioner != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    appointment.practitioner!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontFamily: RtlUtils.getFontFamily(context),
                        ),
                  ),
                ],
              ),
            ],
            if (appointment.location != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    appointment.location!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontFamily: RtlUtils.getFontFamily(context),
                        ),
                  ),
                ],
              ),
            ],
            if (appointment.status != null) ...[
              const SizedBox(height: 12),
              Chip(
                label: Text(
                  appointment.status!.toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: _getStatusColor(appointment.status).withOpacity(0.1),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'booked':
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'noshow':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

