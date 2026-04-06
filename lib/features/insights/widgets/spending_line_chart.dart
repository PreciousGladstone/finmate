import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Spending Line Chart
class SpendingLineChart extends StatelessWidget {
  final Map<String, double> monthlyData;
  final double maxValue;
  final double actualMin;

  const SpendingLineChart({
    super.key,
    required this.monthlyData,
    required this.maxValue,
    required this.actualMin,
  });

  List<FlSpot> _buildSpots() {
    return monthlyData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value.value;
      final range = maxValue - actualMin;
      final normalizedHeight = range == 0 ? 100.0 : ((value - actualMin) / range * 200).toDouble();
      return FlSpot(index.toDouble(), normalizedHeight);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 240,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              _buildLineChartBar(),
            ],
            titlesData: _buildTitlesData(context),
            gridData: _buildGridData(),
            borderData: FlBorderData(show: false),
            lineTouchData: _buildLineTouchData(),
          ),
        ),
      ),
    );
  }

  LineChartBarData _buildLineChartBar() {
    return LineChartBarData(
      spots: _buildSpots(),
      isCurved: true,
      curveSmoothness: 0.4,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryDefault,
          AppColors.primaryDefault.withValues(alpha: 0.2),
        ],
      ),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 5,
          color: AppColors.primaryDefault,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryDefault.withValues(alpha: 0.3),
            AppColors.primaryDefault.withValues(alpha: 0.01),
          ],
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: _buildBottomTitles(context),
      leftTitles: _buildLeftTitles(context),
    );
  }

  AxisTitles _buildBottomTitles(BuildContext context) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 32,
        getTitlesWidget: (value, meta) {
          final keys = monthlyData.keys.toList();
          if (value.toInt() < keys.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                keys[value.toInt()],
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  AxisTitles _buildLeftTitles(BuildContext context) {
    return AxisTitles(
      axisNameWidget: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          'Total\nSpending',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.grey600,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        getTitlesWidget: (value, meta) {
          if (value == 0 || value == 200) {
            final range = maxValue - actualMin;
            final actualValue = range == 0 ? actualMin : (actualMin + (value / 200) * range).toDouble();
            return Text(
              '\$${actualValue.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawHorizontalLine: true,
      drawVerticalLine: false,
      horizontalInterval: 100,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: AppColors.grey200,
          strokeWidth: 1,
          dashArray: [5, 5],
        );
      },
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final keys = monthlyData.keys.toList();
            final month = keys[spot.x.toInt()];
            final range = maxValue - actualMin;
            final actualSpending = range == 0 ? actualMin : (actualMin + (spot.y / 200) * range).toDouble();
            
            return LineTooltipItem(
              '$month\nTotal: \$${actualSpending.toStringAsFixed(2)}',
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
