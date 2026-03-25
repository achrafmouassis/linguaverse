import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/user_progression_model.dart';

class XpLineChart extends StatelessWidget {
  final Map<String, int> xpHistory; // YYYY-MM-DD to cumulative total XP

  const XpLineChart({super.key, required this.xpHistory});

  @override
  Widget build(BuildContext context) {
    if (xpHistory.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("Historique indisponible.")),
      );
    }

    final dates = xpHistory.keys.toList()..sort();
    final List<FlSpot> spots = [];

    int index = 0;
    for (var date in dates) {
      spots.add(FlSpot(index.toDouble(), xpHistory[date]!.toDouble()));
      index++;
    }

    // Add dummy spots if length <= 1
    if (spots.length == 1) {
      spots.insert(0, FlSpot(-1, spots.first.y));
    }

    final double maxVal = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final double maxY = maxVal > 0 ? (maxVal * 1.1) : 100;

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 4).clamp(1.0, 99999.0),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.outline.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: spots.first.x,
          maxX: spots.last.x,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  // Only show dots on potential level ups or start/end
                  if (spot.x == spots.last.x || spot.x == spots.first.x) return true;

                  // Compute level up checks
                  final prevSpot =
                      barData.spots[(spot.x - 1).toInt().clamp(0, barData.spots.length - 1)];
                  final prevLevel = UserProgressionModel.levelFromXP(prevSpot.y.toInt());
                  final currLevel = UserProgressionModel.levelFromXP(spot.y.toInt());
                  return currLevel > prevLevel;
                },
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.surface,
                    strokeWidth: 2,
                    strokeColor: AppColors.primary,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
