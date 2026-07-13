import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Help & Support screen with FAQ, contact options, and support resources.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text('Help & Support', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
          children: [
            _SupportCard(
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              onTap: () {},
            ),
            _SupportCard(
              icon: Icons.email_outlined,
              title: 'Email Us',
              subtitle: 'support@luminagems.com',
              onTap: () {},
            ),
            _SupportCard(
              icon: Icons.phone_outlined,
              title: 'Call Us',
              subtitle: '+1 (800) 555-LUNA',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Text('Frequently Asked Questions', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.md),
            _FaqTile(
              question: 'How do I track my order?',
              answer: 'You can track your order from the Recent Orders section in your profile. Each order includes a tracking number once shipped.',
            ),
            _FaqTile(
              question: 'What is your return policy?',
              answer: 'We offer a 30-day return policy on all gemstones. Items must be returned in original condition with certification papers.',
            ),
            _FaqTile(
              question: 'How are gemstones certified?',
              answer: 'All our gemstones come with certification from GIA (Gemological Institute of America) or equivalent accredited laboratories.',
            ),
            _FaqTile(
              question: 'Do you offer international shipping?',
              answer: 'Yes, we ship worldwide. Shipping costs and delivery times vary by destination. Duties and taxes may apply.',
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusCard,
        child: InkWell(
          borderRadius: AppSpacing.borderRadiusCard,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusCard,
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text(subtitle, style: AppTypography.bodySm.copyWith(color: AppColors.outline)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: AppSpacing.borderRadiusMd,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.question, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.outline, size: 20),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(widget.answer, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
