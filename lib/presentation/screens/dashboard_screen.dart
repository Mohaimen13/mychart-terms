import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mychart_fhir_app/localization/app_localizations.dart';
import 'package:mychart_fhir_app/presentation/providers/auth_provider.dart';
import 'package:mychart_fhir_app/presentation/providers/patient_provider.dart';
import 'package:mychart_fhir_app/presentation/screens/labs_screen.dart';
import 'package:mychart_fhir_app/presentation/screens/medications_screen.dart';
import 'package:mychart_fhir_app/presentation/screens/appointments_screen.dart';
import 'package:mychart_fhir_app/core/utils/rtl_utils.dart';

/// Dashboard Screen
/// 
/// Main home screen showing patient overview and quick access
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load patient data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadPatient();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRtl = RtlUtils.isRtl(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.appTitle,
          style: TextStyle(fontFamily: RtlUtils.getFontFamily(context)),
        ),
        actions: [
          // Language switcher
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // TODO: Implement locale switching
            },
            tooltip: isRtl ? 'English' : 'العربية',
          ),
          // Logout
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(localizations.logout),
                      content: Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(localizations.logout),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await authProvider.logout();
                  }
                },
                tooltip: localizations.logout,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PatientProvider>().loadPatient();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Patient Info Card
              Consumer<PatientProvider>(
                builder: (context, patientProvider, child) {
                  if (patientProvider.isLoading) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (patientProvider.errorMessage != null) {
                    return Card(
                      color: Colors.red[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[700]),
                            const SizedBox(height: 8),
                            Text(
                              patientProvider.errorMessage!,
                              style: TextStyle(color: Colors.red[700]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => patientProvider.loadPatient(),
                              child: Text(localizations.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final patient = patientProvider.patient;
                  if (patient == null) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient.fullName ?? '${patient.firstName ?? ''} ${patient.lastName ?? ''}'.trim(),
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: RtlUtils.getFontFamily(context),
                                          ),
                                    ),
                                    if (patient.birthDate != null)
                                      Text(
                                        'DOB: ${DateFormat('MMM dd, yyyy').format(patient.birthDate!)}',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.grey[600],
                                              fontFamily: RtlUtils.getFontFamily(context),
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Quick Access Cards
              Text(
                'Quick Access',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: RtlUtils.getFontFamily(context),
                    ),
              ),
              const SizedBox(height: 16),

              // Labs & Vitals Card
              _QuickAccessCard(
                icon: Icons.science,
                title: localizations.labs,
                subtitle: 'View lab results and vital signs',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LabsScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Medications Card
              _QuickAccessCard(
                icon: Icons.medication,
                title: localizations.medications,
                subtitle: 'View current medications',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MedicationsScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Appointments Card
              _QuickAccessCard(
                icon: Icons.calendar_today,
                title: localizations.appointments,
                subtitle: 'View upcoming and past appointments',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppointmentsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = RtlUtils.isRtl(context);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: RtlUtils.getFontFamily(context),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontFamily: RtlUtils.getFontFamily(context),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                isRtl ? Icons.chevron_left : Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

