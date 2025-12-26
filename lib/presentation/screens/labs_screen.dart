import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mychart_fhir_app/localization/app_localizations.dart';
import 'package:mychart_fhir_app/presentation/providers/observations_provider.dart';
import 'package:mychart_fhir_app/core/utils/rtl_utils.dart';

/// Labs & Vitals Screen
/// 
/// Displays laboratory results and vital signs
class LabsScreen extends StatefulWidget {
  const LabsScreen({super.key});

  @override
  State<LabsScreen> createState() => _LabsScreenState();
}

class _LabsScreenState extends State<LabsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load observations when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ObservationsProvider>().loadObservations();
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
    final isRtl = RtlUtils.isRtl(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${localizations.labs} & ${localizations.vitals}',
          style: TextStyle(fontFamily: RtlUtils.getFontFamily(context)),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: localizations.labs,
              icon: const Icon(Icons.science),
            ),
            Tab(
              text: localizations.vitals,
              icon: const Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ObservationsProvider>().loadObservations();
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _LabsTab(),
            _VitalsTab(),
          ],
        ),
      ),
    );
  }
}

class _LabsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<ObservationsProvider>(
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
                  onPressed: () => provider.loadLabs(),
                  child: Text(localizations.retry),
                ),
              ],
            ),
          );
        }

        if (provider.labs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.science_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No lab results available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.labs.length,
          itemBuilder: (context, index) {
            final lab = provider.labs[index];
            return _ObservationCard(observation: lab);
          },
        );
      },
    );
  }
}

class _VitalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<ObservationsProvider>(
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
                  onPressed: () => provider.loadVitals(),
                  child: Text(localizations.retry),
                ),
              ],
            ),
          );
        }

        if (provider.vitals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No vital signs available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.vitals.length,
          itemBuilder: (context, index) {
            final vital = provider.vitals[index];
            return _ObservationCard(observation: vital);
          },
        );
      },
    );
  }
}

class _ObservationCard extends StatelessWidget {
  final dynamic observation; // ObservationModel

  const _ObservationCard({required this.observation});

  @override
  Widget build(BuildContext context) {
    final isRtl = RtlUtils.isRtl(context);
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    observation.displayName ?? observation.code ?? 'Unknown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: RtlUtils.getFontFamily(context),
                        ),
                  ),
                ),
                if (observation.effectiveDateTime != null)
                  Text(
                    dateFormat.format(observation.effectiveDateTime!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontFamily: RtlUtils.getFontFamily(context),
                        ),
                  ),
              ],
            ),
            if (observation.value != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    observation.value!,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: RtlUtils.getFontFamily(context),
                        ),
                  ),
                  if (observation.unit != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      observation.unit!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontFamily: RtlUtils.getFontFamily(context),
                          ),
                    ),
                  ],
                ],
              ),
            ],
            if (observation.status != null) ...[
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  observation.status!.toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: _getStatusColor(observation.status).withOpacity(0.1),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'final':
        return Colors.green;
      case 'preliminary':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

