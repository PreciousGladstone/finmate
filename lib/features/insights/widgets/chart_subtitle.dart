import 'package:finmate/core/themes/app_color.dart';
import 'package:flutter/material.dart';

/// Chart Subtitle
class ChartSubtitle extends StatelessWidget {
  const ChartSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Your total spending across 6 months',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.grey600,
      ),
    );
  }
}
