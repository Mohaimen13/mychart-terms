import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mychart_fhir_app/localization/app_localizations.dart';
import 'package:mychart_fhir_app/presentation/providers/medications_provider.dart';
import 'package:mychart_fhir_app/core/utils/rtl_utils.dart';

/// Medications Screen
/// 
/// Displays current medications
class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.medications,
          style: TextStyle(fontFamily: RtlUtils.getFontFamily(context)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<MedicationsProvider>().loadMedications();
        },
        child: Consumer<MedicationsProvider>(
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
                      onPressed: () => provider.loadMedications(),
                      child: Text(localizations.retry),
                    ),
                  ],
                ),
              );
            }

            if (provider.medications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medication_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No medications found',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.medications.length,
              itemBuilder: (context, index) {
                final medication = provider.medications[index];
                return _MedicationCard(medication: medication);
              },
            );
          },
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final dynamic medication; // MedicationRequestModel

  const _MedicationCard({required this.medication});

  @override
  Widget build(BuildContext context) {
    final isRtl = RtlUtils.isRtl(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.medication,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    medication.medicationName ?? 'Unknown Medication',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: RtlUtils.getFontFamily(context),
                        ),
                  ),
                ),
              ],
            ),
            if (medication.dosageInstruction != null) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      medication.dosageInstruction!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: RtlUtils.getFontFamily(context),
                          ),
                    ),
                  ),
                ],
              ),
            ],
            if (medication.authoredOn != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Prescribed: ${dateFormat.format(medication.authoredOn!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontFamily: RtlUtils.getFontFamily(context),
                        ),
                  ),
                ],
              ),
            ],
            if (medication.prescriber != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    medication.prescriber!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontFamily: RtlUtils.getFontFamily(context),
                        ),
                  ),
                ],
              ),
            ],
            if (medication.status != null) ...[
              const SizedBox(height: 12),
              Chip(
                label: Text(
                  medication.status!.toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: _getStatusColor(medication.status).withOpacity(0.1),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'stopped':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }
}

