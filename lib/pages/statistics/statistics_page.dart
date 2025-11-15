import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dentiste/pages/statistics/widgets/chart_widget.dart';
import 'package:dentiste/pages/statistics/widgets/stat_summary.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final selectedYear = DateTime(selectedMonth.year);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Statistiques du cabinet'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sélecteur de mois
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mois sélectionné : ${DateFormat.yMMMM('fr_FR').format(selectedMonth)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Changer'),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedMonth,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          helpText: 'Sélectionner un mois',
                        );
                        if (picked != null) {
                          setState(() {
                            selectedMonth = DateTime(picked.year, picked.month);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Résumé des statistiques
            StatSummary(selectedMonth: selectedMonth),
            const SizedBox(height: 24),
            // Graphique des revenus
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ChartWidget(selectedYear: selectedYear),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
