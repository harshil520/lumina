import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';

/// Screen displaying the Lumina Gems Raise a Query options.
///
/// Features a prestige hero section, value bento grid, and interactive inquiry form.
class RaiseQueryScreen extends StatefulWidget {
  const RaiseQueryScreen({super.key});

  @override
  State<RaiseQueryScreen> createState() => _RaiseQueryScreenState();
}

class _RaiseQueryScreenState extends State<RaiseQueryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _servicesKey = GlobalKey();
  final _formSectionKey = GlobalKey();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  String _interestedIn = 'Engagement Rings';
  String _budgetRange = '\$10,000 - \$25,000';

  bool _isSubmitting = false;
  bool _isSuccess = false;

  final List<String> _interests = [
    'Engagement Rings',
    'Rare Gemstones',
    'Investment Portfolio',
    'Heirloom Restoration',
  ];

  final List<String> _budgets = [
    '\$10,000 - \$25,000',
    '\$25,000 - \$100,000',
    '\$100,000 - \$500,000',
    '\$500,000+',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Simulate luxury ledger routing delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isSuccess = true;
      });

      // Clear fields
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();

      // Reset success state after a delay
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _isSuccess = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientGradientBackground.home(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Header Bar ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingH,
                  AppSpacing.sm,
                  AppSpacing.screenPaddingH,
                  isMobile ? AppSpacing.sm : AppSpacing.md,
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
                      'RAISE A QUERY',
                      style: AppTypography.titleLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: isMobile ? 15 : 17,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Scrollable Body ─────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroSection(isMobile),
                      _buildBentoSection(isMobile),
                      _buildFormSection(isMobile),
                      _buildQuoteSection(isMobile),
                      SizedBox(height: isMobile ? 24 : 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    final heroHeight = isMobile ? 380.0 : 440.0;
    final displayStyle = isMobile
        ? AppTypography.display.copyWith(fontSize: 28)
        : AppTypography.display;
    final double innerPadding = isMobile ? 16 : 24;

    return Container(
      width: double.infinity,
      height: heroHeight,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
      decoration: BoxDecoration(
        borderRadius: AppSpacing.borderRadiusXl,
        boxShadow: AppSpacing.elevationMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Gemologist Image
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDO7XdeyvvrQjlJzyxjp28CQUmq37SGrTyK875WW5P6I5_JuUNxBJyDcxWK40tWGi6xM3HScvcNvMQqtfODw0t3wQXg-_kTi6DL6J20xT24Uu6-zQNAmsiN8QbnoTTZu79b9kHkNA_xW4tVEjDP3Ey8NWjRwU-9FvX87MTANPqNnbnlqDNMf7F7GvR8EiyFpoITDvZUgklWKhq9m092SNXrzeWhXlZ03M9hVOefEF1zcWi2cWsquZC6chduSjmvALgnNdjEDZsD4to',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          // Dark/Emerald overlay to balance text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.surfaceDim.withValues(alpha: 0.95),
                    AppColors.surfaceDim.withValues(alpha: 0.70),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          // Hero Text Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: innerPadding, vertical: isMobile ? 20 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixed,
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                  child: Text(
                    'RAISE A QUERY',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onTertiaryFixed,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 16),
                Text(
                  'Your Vision,\nSculpted in Light.',
                  style: displayStyle.copyWith(
                    color: AppColors.primary,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 16),
                SizedBox(
                  width: isMobile ? double.infinity : 260,
                  child: Text(
                    'Lumina\'s expert gemologists are ready to assist you with rare stone inquiries, bespoke commissions, and investment portfolio guidance.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    GestureDetector(
                      onTap: () => _scrollToKey(_formSectionKey),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Text(
                          'RAISE A QUERY',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _scrollToKey(_servicesKey),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary, width: 1.2),
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Text(
                          'VIEW SERVICES',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoSection(bool isMobile) {
    final double sectionPaddingV = isMobile ? 16 : AppSpacing.xl;
    final double sectionPaddingH = AppSpacing.screenPaddingH;
    final double cardSpacing = isMobile ? 12 : 24;

    return Container(
      key: _servicesKey,
      padding: EdgeInsets.fromLTRB(
        sectionPaddingH,
        sectionPaddingV,
        sectionPaddingH,
        isMobile ? 16 : AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beyond the Gallery',
            style: AppTypography.headlineLg.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Access a world of rare stones and unparalleled services reserved for our most valued clients.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          SizedBox(height: cardSpacing),

          // Bento Cards (Custom Grid Layout)
          // 1. Global Network Sourcing (Wide Card)
          _buildBentoCard(
            icon: Icons.public_rounded,
            iconColor: AppColors.primary,
            title: 'Global Network Sourcing',
            description:
                'Our network spans the mines of Muzo to the cutting houses of Antwerp. We secure the first right of refusal on high-carat, investment-grade stones before they ever reach the public market.',
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),

          // Row of Bespoke Artisanry & Expert Verification
          if (!isMobile)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildBespokeArtisanryCard(false)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildExpertVerificationCard(false)),
                ],
              ),
            )
          else ...[
            _buildBespokeArtisanryCard(true),
            const SizedBox(height: 12),
            _buildExpertVerificationCard(true),
          ],
          const SizedBox(height: 12),

          // Insured Transit & Portfolio Strategy Row
          if (!isMobile)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildInsuredTransitCard(false)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPortfolioStrategyCard(false)),
                ],
              ),
            )
          else ...[
            _buildInsuredTransitCard(true),
            const SizedBox(height: 12),
            _buildPortfolioStrategyCard(true),
          ],
        ],
      ),
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isMobile,
    Color? backgroundColor,
    Gradient? gradient,
    Color? textColor,
    Color? descColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        gradient: gradient,
        borderRadius: AppSpacing.borderRadiusLg,
        border: gradient != null ? null : Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: AppSpacing.elevationSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTypography.bodyLg.copyWith(
              color: textColor ?? AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTypography.bodySm.copyWith(
              color: descColor ?? AppColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBespokeArtisanryCard(bool isMobile) {
    return _buildBentoCard(
      icon: Icons.auto_awesome_rounded,
      iconColor: AppColors.onPrimary,
      title: 'Bespoke Artisanry',
      description: 'Work with our creative directors to design a setting.',
      isMobile: isMobile,
      gradient: AppColors.primaryGradient,
      textColor: AppColors.onPrimary,
      descColor: AppColors.onPrimary.withValues(alpha: 0.8),
    );
  }

  Widget _buildExpertVerificationCard(bool isMobile) {
    return _buildBentoCard(
      icon: Icons.verified_user_outlined,
      iconColor: AppColors.secondary,
      title: 'Expert Verification',
      description: 'Triple-certified authentication processes for every gem.',
      isMobile: isMobile,
    );
  }

  Widget _buildInsuredTransitCard(bool isMobile) {
    return _buildBentoCard(
      icon: Icons.local_shipping_outlined,
      iconColor: AppColors.primary,
      title: 'Insured Transit',
      description: 'Armored transport options for high-value assets.',
      isMobile: isMobile,
    );
  }

  Widget _buildPortfolioStrategyCard(bool isMobile) {
    return _buildBentoCard(
      icon: Icons.show_chart,
      iconColor: AppColors.tertiary,
      title: 'Portfolio Strategy',
      description: 'Annual appraisals to track asset valuation.',
      isMobile: isMobile,
    );
  }

  Widget _buildFormSection(bool isMobile) {
    final double paddingH = isMobile ? 16 : 20;
    final double paddingV = isMobile ? 20 : 28;

    return Container(
      key: _formSectionKey,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: AppSpacing.elevationLg,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Subtle high-contrast refraction background image under formulation layout
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuC1K3GphU4xX4fEw23wEChUgZei9HivJ6C1IdEG6gdEsAG6ifY1-YA2mrti4o9wS3RJS9Xl3r3P1Fwr1HfIE3goZBMmCAszJnHC3BkIA6PefX4lWdQ_EmqMhc3rUHuLPoSMos5aphGrUtREO1ysjeCAzWpvipAtTyXWEH_C8_8aXudRqh8urpS0HHtRV9PEph8T_m2rHSRoDurFKiOhwm9BYrmIuO9NS36buV_sREl0st0AglxnfdORBpe9S_LGAbmKiyxly1cqi28',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Begin Your Journey',
                    style: AppTypography.headlineLg.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Complete the inquiry below. Your assigned advisor will contact you within 24 hours with absolute discretion.',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),

                  if (_isSuccess) ...[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: AppColors.secondary,
                              size: 56,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Inquiry Sent Successfully',
                              style: AppTypography.titleLg.copyWith(color: AppColors.primary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'A member of our team will review your request and reach out shortly.',
                              style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Full Name Input
                    _buildTextLabel('FULL NAME'),
                    TextFormField(
                      controller: _nameController,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
                      decoration: _buildInputDecoration('Enter your full name'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 18),

                    // Email Address Input
                    _buildTextLabel('EMAIL ADDRESS'),
                    TextFormField(
                      controller: _emailController,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration('Enter your email address'),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        final reg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!reg.hasMatch(v)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Interested In Dropdown
                    _buildTextLabel('INTERESTED IN'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _interestedIn,
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.outline),
                          style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
                          items: _interests.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() {
                                _interestedIn = v;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Budget Range Dropdown
                    _buildTextLabel('BUDGET RANGE'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _budgetRange,
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.outline),
                          style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
                          items: _budgets.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() {
                                _budgetRange = v;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Message Field
                    _buildTextLabel('MESSAGE / VISION DESCRIPTION'),
                    TextFormField(
                      controller: _messageController,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
                      maxLines: 4,
                      decoration: _buildInputDecoration(
                        'Describe your vision or the specific stone characteristics you are seeking...',
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Please describe your request' : null,
                    ),
                    const SizedBox(height: 28),

                    // Submit Button
                    GestureDetector(
                      onTap: _isSubmitting ? null : _submitForm,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: AppSpacing.borderRadiusDefault,
                          boxShadow: AppSpacing.elevationPrimary,
                        ),
                        alignment: Alignment.center,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.onPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'SUBMIT INQUIRY',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onPrimary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : AppSpacing.gutter,
        vertical: isMobile ? 24 : AppSpacing.xl,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.format_quote_rounded,
            size: 48,
            color: AppColors.tertiaryFixedDim,
          ),
          const SizedBox(height: 12),
          Text(
            '"True luxury is not just what you see, but the narrative of how it was discovered."',
            style: GoogleFonts.playfairDisplay(
              fontSize: isMobile ? 17 : 20,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 48,
            height: 1.2,
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'ELIAS THORNE',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Master Gemologist',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: AppColors.outline,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodySm.copyWith(
        color: AppColors.outlineVariant.withValues(alpha: 0.8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: AppColors.surface,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.0,
        ),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
    );
  }
}
