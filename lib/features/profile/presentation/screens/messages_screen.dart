import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/profile_providers.dart';
import '../../domain/models/message.dart';

/// Screen showing the user's inbox/messages.
class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text('Messages', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: messagesAsync.when(
          data: (messages) {
            if (messages.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail_outline, size: 64, color: AppColors.outline),
                    SizedBox(height: AppSpacing.md),
                    Text('No messages yet', style: TextStyle(color: AppColors.outline, fontSize: 16)),
                    SizedBox(height: AppSpacing.sm),
                    Text('Messages from sellers and support will appear here', style: TextStyle(color: AppColors.outline, fontSize: 13)),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
              itemCount: messages.length,
              itemBuilder: (context, index) => _MessageCard(message: messages[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Could not load messages: $err', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});
  final Message message;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: message.isRead ? AppColors.surface : AppColors.primaryContainer.withValues(alpha: 0.35),
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(
          color: message.isRead
              ? AppColors.outlineVariant.withValues(alpha: 0.15)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
        boxShadow: message.isRead ? AppSpacing.elevationSm : AppSpacing.elevationPrimary,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Center(
              child: Text(
                message.senderName.isNotEmpty ? message.senderName[0].toUpperCase() : '?',
                style: AppTypography.titleLg.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        message.senderName,
                        style: AppTypography.bodyMd.copyWith(
                          fontWeight: message.isRead ? FontWeight.w500 : FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(message.timestamp),
                      style: AppTypography.badge.copyWith(
                        color: message.isRead ? AppColors.outline : AppColors.primary,
                        fontWeight: message.isRead ? FontWeight.w400 : FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message.preview,
                  style: AppTypography.bodySm.copyWith(
                    color: message.isRead ? AppColors.onSurfaceVariant : AppColors.onSurface,
                    fontWeight: message.isRead ? FontWeight.w400 : FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!message.isRead)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
