import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';

class BookConsultantScreen extends StatefulWidget {
  const BookConsultantScreen({super.key});

  @override
  State<BookConsultantScreen> createState() => _BookConsultantScreenState();
}

class _BookConsultantScreenState extends State<BookConsultantScreen> {
  int _selectedConsultant = 0;
  int _selectedDate = 0;
  int _selectedTime = -1;
  bool _isSubmitting = false;
  bool _isSuccess = false;

  final List<(String, String, String, double)> _consultants = [
    (
      'Sarah Sterling',
      'Senior Gemologist',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80',
      4.9
    ),
    (
      'David Vance',
      'Bespoke Valuation Lead',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
      4.8
    ),
    (
      'Helena Rostova',
      'Investment Asset Advisor',
      'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&q=80',
      5.0
    ),
  ];

  final List<(String, String)> _dates = [
    ('Mon', 'Jul 13'),
    ('Tue', 'Jul 14'),
    ('Wed', 'Jul 15'),
    ('Thu', 'Jul 16'),
    ('Fri', 'Jul 17'),
    ('Sat', 'Jul 18'),
  ];

  final List<String> _slots = [
    '09:00 AM',
    '10:30 AM',
    '11:00 AM',
    '01:30 PM',
    '03:00 PM',
    '04:30 PM',
  ];

  void _bookConsultation() async {
    if (_selectedTime == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an available consultation slot.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate ledger/booking reservation
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientGradientBackground.home(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPaddingH,
                      AppSpacing.sm,
                      AppSpacing.screenPaddingH,
                      AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: AppSpacing.borderRadiusMd,
                              border: Border.all(
                                color: AppColors.outlineVariant.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'PRIVATE CONCIERGE',
                          style: AppTypography.titleLg.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPaddingH,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SELECT SPECIALIST',
                            style: AppTypography.overline.copyWith(
                              color: AppColors.outline,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Consultants list
                          ...List.generate(_consultants.length, (index) {
                            final c = _consultants[index];
                            final isSelected = _selectedConsultant == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedConsultant = index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.outlineVariant.withValues(alpha: 0.2),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  borderRadius: AppSpacing.borderRadiusCard,
                                  boxShadow: isSelected
                                      ? AppSpacing.elevationMd
                                      : AppSpacing.elevationSm,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(
                                        c.$3,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c.$1,
                                            style: AppTypography.bodyMd.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            c.$2,
                                            style: AppTypography.bodySm.copyWith(
                                              color: AppColors.outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: AppColors.accentAmber,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${c.$4}',
                                          style: AppTypography.dataMono.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 20),

                          Text(
                            'SELECT DATE',
                            style: AppTypography.overline.copyWith(
                              color: AppColors.outline,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Horizontal dates picker
                          SizedBox(
                            height: 64,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _dates.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final d = _dates[index];
                                final isSelected = _selectedDate == index;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedDate = index),
                                  child: Container(
                                    width: 64,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.surface,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.outlineVariant.withValues(
                                                alpha: 0.25,
                                              ),
                                      ),
                                      borderRadius: AppSpacing.borderRadiusCard,
                                      boxShadow: AppSpacing.elevationSm,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          d.$1,
                                          style: AppTypography.badge.copyWith(
                                            color: isSelected
                                                ? AppColors.onPrimary
                                                    .withValues(alpha: 0.6)
                                                : AppColors.outline,
                                            fontSize: 9,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          d.$2.split(' ')[1],
                                          style: AppTypography.bodySm.copyWith(
                                            color: isSelected
                                                ? AppColors.onPrimary
                                                : AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          Text(
                            'AVAILABLE SLOTS',
                            style: AppTypography.overline.copyWith(
                              color: AppColors.outline,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Slots Grid
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 2.2,
                            ),
                            itemCount: _slots.length,
                            itemBuilder: (context, index) {
                              final slot = _slots[index];
                              final isSelected = _selectedTime == index;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedTime = index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.tertiary
                                        : AppColors.surface,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.tertiary
                                          : AppColors.outlineVariant.withValues(
                                              alpha: 0.2,
                                            ),
                                    ),
                                    borderRadius: AppSpacing.borderRadiusMd,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    slot,
                                    style: AppTypography.labelSm.copyWith(
                                      color: isSelected
                                          ? AppColors.onTertiary
                                          : AppColors.primary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 36),

                          // Book Button
                          GestureDetector(
                            onTap: _bookConsultation,
                            child: Container(
                              height: 52,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: AppSpacing.borderRadiusDefault,
                                boxShadow: AppSpacing.elevationPrimary,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'BOOK SECURE APPOINTMENT',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_isSubmitting)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.tertiary,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
              if (_isSuccess)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppSpacing.borderRadiusLg,
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.done_rounded,
                              color: AppColors.secondary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Consultation Reserved',
                            style: AppTypography.titleLg.copyWith(
                              fontFamily: 'Playfair Display',
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'A private video link and portfolio briefing deck have been sent to your secure messaging threads with ${_consultants[_selectedConsultant].$1}.',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 44,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                                borderRadius: AppSpacing.borderRadiusDefault,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'RETURN TO HOME',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
