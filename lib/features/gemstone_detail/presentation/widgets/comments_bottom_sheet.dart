import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/comments_provider.dart';

class CommentsBottomSheet extends ConsumerStatefulWidget {
  const CommentsBottomSheet({super.key, required this.gemstoneId});

  final String gemstoneId;

  @override
  ConsumerState<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends ConsumerState<CommentsBottomSheet> {
  double _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _commentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a comment before posting.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ref.read(gemstoneCommentsProvider(widget.gemstoneId).notifier).addComment(_rating, text);
    context.pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review recorded successfully on vault ledger.'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, bottomPadding + 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        boxShadow: AppSpacing.elevationLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Write a Review',
            style: AppTypography.titleLg.copyWith(
              fontFamily: 'Playfair Display',
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Share your appraisal and purchase feedback.',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 20),

          // Rating selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1.0;
              return GestureDetector(
                onTap: () => setState(() => _rating = starValue),
                child: Icon(
                  starValue <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 36,
                  color: AppColors.accentAmber,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Comment Text Field
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.25),
              ),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Describe your verification experience or certificate quality...',
                hintStyle: AppTypography.bodySm.copyWith(
                  color: AppColors.outline.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Post Button
          GestureDetector(
            onTap: _submit,
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: AppSpacing.borderRadiusDefault,
              ),
              alignment: Alignment.center,
              child: Text(
                'POST SECURE REVIEW',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
