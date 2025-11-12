import 'package:dentiste/pages/statistics/widgets/chart_widget.dart';
import 'package:dentiste/pages/statistics/widgets/stat_summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mois sélectionné : ${DateFormat.yMMMM().format(selectedMonth)}',
                  style: const TextStyle(fontSize: 16),
                ),
                TextButton(
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
                  child: const Text('Changer'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Résumé des statistiques
            StatSummary(selectedMonth: selectedMonth),
            const SizedBox(height: 24),
            // Graphique des revenus
            Expanded(child: ChartWidget(selectedYear: selectedYear)),
          ],
        ),
      ),
    );
  }
}
