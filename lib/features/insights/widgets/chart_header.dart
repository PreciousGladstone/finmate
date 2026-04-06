import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Chart Header with title and info tooltip
class ChartHeader extends StatelessWidget {
  const ChartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.monthlyTrend,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        Tooltip(
          message: 'Tap any point to see your total spending for that month. The chart scales to show spending from lowest to highest month.',
          child: Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }
}
