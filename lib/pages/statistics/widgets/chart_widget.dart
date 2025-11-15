import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartWidget extends StatelessWidget {
  final DateTime selectedYear;
  const ChartWidget({super.key, required this.selectedYear});

  @override
  Widget build(BuildContext context) {
    final start = Timestamp.fromDate(DateTime(selectedYear.year, 1));
    final end = Timestamp.fromDate(DateTime(selectedYear.year + 1, 1));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('factures')
          .where('dateTime', isGreaterThanOrEqualTo: start)
          .where('dateTime', isLessThan: end)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final monthlyRevenue = List<double>.filled(12, 0.0);
        double totalFactures = 0.0;
        double totalPaye = 0.0;
        double totalPartiel = 0.0;
        double totalImpaye = 0.0;

        for (final doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final date = (data['dateTime'] as Timestamp).toDate();
          final montantPaye = data['montantPaye'];
          final montantTotal = data['montantTotal'];
          final resteAPayer = data['resteAPayer'];

          if (montantPaye is num && montantTotal is num && resteAPayer is num) {
            monthlyRevenue[date.month - 1] += montantPaye.toDouble();
            totalFactures += montantTotal.toDouble();

            if (resteAPayer == 0) {
              totalPaye += montantTotal.toDouble();
            } else if (montantPaye > 0) {
              totalPartiel += resteAPayer.toDouble();
            } else {
              totalImpaye += montantTotal.toDouble();
            }
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📈 Revenus mensuels',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    minX: 1,
                    maxX: 12,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 1,
                          getTitlesWidget: (value, _) {
                            final index = value.toInt();
                            if (index >= 1 && index <= 12) {
                              return Text(
                                DateFormat.MMM('fr_FR').format(DateTime(0, index)),
                                style: Theme.of(context).textTheme.labelSmall,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(12, (i) => FlSpot((i + 1).toDouble(), monthlyRevenue[i])),
                        isCurved: true,
                        color: Theme.of(context).primaryColor,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '📊 Statistiques par statut de paiement',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '💰 Montant total des factures : ${totalFactures.toStringAsFixed(2)} TND',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            switch (value.toInt()) {
                              case 0:
                                return Text('Payé', style: Theme.of(context).textTheme.labelSmall);
                              case 1:
                                return Text('Partiel', style: Theme.of(context).textTheme.labelSmall);
                              case 2:
                                return Text('Impayé', style: Theme.of(context).textTheme.labelSmall);
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                          toY: totalPaye,
                          color: Colors.green,
                          width: 22,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                          toY: totalPartiel,
                          color: Colors.orange,
                          width: 22,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                          toY: totalImpaye,
                          color: Colors.red,
                          width: 22,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ]),
                    ],
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
