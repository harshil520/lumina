import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/home_providers.dart';
import 'gemstone_card.dart';

/// Two-column product grid for trending gemstones.
///
/// Uses a simple Column-based layout since the item count is small (6 items).
/// For larger paginated lists, this would use ListView.builder per
/// performance.md rules.
class TrendingGemstonesGrid extends ConsumerWidget {
  const TrendingGemstonesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gemstonesAsync = ref.watch(trendingGemstonesProvider);

    return gemstonesAsync.when(
      data: (gemstones) {
        // Build 2-column grid manually for the fixed small list
        final rows = <Widget>[];
        for (var i = 0; i < gemstones.length; i += 2) {
          rows.add(
            Padding(
              padding: EdgeInsets.only(
                bottom: i + 2 < gemstones.length ? 16 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GemstoneCard(gemstone: gemstones[i]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: i + 1 < gemstones.length
                        ? GemstoneCard(gemstone: gemstones[i + 1])
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
          ),
          child: Column(children: rows),
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
