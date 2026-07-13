import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Scanned certificate result model to pre-populate new listings.
class ScannedCertState {
  const ScannedCertState({
    required this.caratWeight,
    required this.colorGrade,
    required this.clarityGrade,
    required this.cutGrade,
    required this.giaReportNumber,
  });

  final String caratWeight;
  final String colorGrade;
  final String clarityGrade;
  final String cutGrade;
  final String giaReportNumber;
}

/// Provider to share scanned certificate details with the listing form modal.
final scannedCertProvider = StateProvider<ScannedCertState?>((ref) => null);

/// Certification Upload and Verification Screen for Sellers.
///
/// Simulates dragging/uploading GIA gemstone reports, running OCR extraction
/// with animated scanner visuals, querying GIA database API, and pre-filling listings.
class CertificationUploadScreen extends ConsumerStatefulWidget {
  const CertificationUploadScreen({super.key});

  @override
  ConsumerState<CertificationUploadScreen> createState() => _CertificationUploadScreenState();
}

class _CertificationUploadScreenState extends ConsumerState<CertificationUploadScreen> with SingleTickerProviderStateMixin {
  // Stepper active state (1 = Upload, 2 = Extract, 3 = Verify)
  int _activeStep = 1;

  // File upload state
  bool _isFileUploaded = false;

  // Scanning animation states
  late AnimationController _scannerController;
  bool _isScanComplete = false;

  // GIA Sync states
  bool _syncStep1 = false; // Document integrity
  bool _syncStep2 = false; // Serial match
  bool _syncStep3 = false; // Authentic signatures (loading -> complete)
  bool _isSyncComplete = false;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  // Simulate file drop/select
  void _onUploadFile() {
    setState(() {
      _isFileUploaded = true;
      _activeStep = 2;
    });

    // Start scanner animation
    _scannerController.repeat(reverse: true);

    // After 3.5 seconds, complete OCR extraction and move to sync
    Timer(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      setState(() {
        _isScanComplete = true;
        _activeStep = 3;
      });
      _scannerController.stop();
      _startDatabaseSync();
    });
  }

  // Simulate the GIA database checking sequence
  void _startDatabaseSync() {
    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _syncStep1 = true);
    });

    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _syncStep2 = true);
    });

    Timer(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      setState(() {
        _syncStep3 = true;
        _isSyncComplete = true;
      });
    });
  }

  // finalize and pass mock extracted data to provider
  void _onFinalize() {
    ref.read(scannedCertProvider.notifier).state = const ScannedCertState(
      caratWeight: '2.05 ct',
      colorGrade: 'D (Colorless)',
      clarityGrade: 'VVS1',
      cutGrade: 'Round',
      giaReportNumber: '#GIA6422190874',
    );
    context.pop(true); // Return true to indicate successful scan
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 960;
    final isMobile = width < 600;

    final double screenPaddingH = isMobile ? 12 : AppSpacing.gutter;

    return Scaffold(
      backgroundColor: AppColors.surfaceDim,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildHeader(isMobile),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: isMobile ? 16 : 24),
            // Title & Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Stone Certification',
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.primary,
                      fontSize: isMobile ? 22 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Securely upload and verify your gemstone certificates. Our AI-driven system automatically extracts technical specifications to speed up your listing process.',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),

            // Stepper Navigation
            _buildStepperTracker(isMobile),
            SizedBox(height: isMobile ? 16 : 24),

            // Main Columns
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenPaddingH),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildUploadAndScannerColumn(isMobile)),
                        const SizedBox(width: AppSpacing.gutter * 1.5),
                        Expanded(flex: 5, child: _buildVerificationColumn(isMobile)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUploadAndScannerColumn(isMobile),
                        SizedBox(height: isMobile ? 16 : AppSpacing.lg),
                        _buildVerificationColumn(isMobile),
                        SizedBox(height: isMobile ? 24 : 48),
                      ],
                    ),
            ),
            SizedBox(height: isMobile ? 24 : 48),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : AppSpacing.screenPaddingH,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      isMobile ? 'BACK' : 'BACK TO DASHBOARD',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'LUMINA GEMS',
                style: GoogleFonts.playfairDisplay(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),
              Text(
                isMobile ? 'SELLER' : 'SELLER PORTAL',
                style: AppTypography.labelSm.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.onSurfaceVariant,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperTracker(bool isMobile) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showLabels = screenWidth > 480;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : AppSpacing.gutter),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: AppSpacing.elevationSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildStepperNode(1, 'UPLOAD', _activeStep >= 1, showLabels),
          _buildStepperConnector(_activeStep >= 2, isMobile),
          _buildStepperNode(2, 'EXTRACT', _activeStep >= 2, showLabels),
          _buildStepperConnector(_activeStep >= 3, isMobile),
          _buildStepperNode(3, 'VERIFY', _activeStep >= 3, showLabels),
        ],
      ),
    );
  }

  Widget _buildStepperNode(int step, String label, bool isActive, bool showLabels) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$step',
            style: AppTypography.labelSm.copyWith(
              color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        if (showLabels) ...[
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStepperConnector(bool isActive, bool isMobile) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
        height: 1,
        color: isActive ? AppColors.primary : AppColors.outlineVariant,
      ),
    );
  }

  Widget _buildUploadAndScannerColumn(bool isMobile) {
    final cardPadding = isMobile ? 14.0 : 20.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card 1: Certificate Upload Drag & Drop Area
        Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
            side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certificate Upload',
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Drag zone
                GestureDetector(
                  onTap: _onUploadFile,
                  child: Container(
                    height: isMobile ? 220 : 200,
                    decoration: BoxDecoration(
                      color: _isFileUploaded ? AppColors.primaryContainer.withValues(alpha: 0.05) : AppColors.surfaceContainerLow,
                      borderRadius: AppSpacing.borderRadiusLg,
                      border: Border.all(
                        color: _isFileUploaded ? AppColors.primary : AppColors.outlineVariant,
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.upload_file_rounded, color: AppColors.primary, size: 24),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _isFileUploaded ? 'Uploaded Successfully' : 'Drag & drop certificate',
                              style: AppTypography.bodyLg.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: isMobile ? 15 : 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Supports GIA, IGI, or HRD (PDF, JPG, PNG up to 15MB)',
                              style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            if (!_isFileUploaded)
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ElevatedButton(
                                    onPressed: _onUploadFile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                    child: const Text('Browse Files'),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: _onUploadFile,
                                    icon: const Icon(Icons.photo_camera_rounded, size: 14),
                                    label: const Text('Mobile Scan'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(color: AppColors.primary),
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.info_outline_rounded, size: 14, color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Ensure all four corners of the document are visible for optimal data extraction.',
                        style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Card 2: Live scan preview (always active when processing, or placeholder)
        if (_isFileUploaded)
          Card(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusLg,
              side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live Document Scan',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isScanComplete ? AppColors.secondaryContainer : AppColors.tertiaryContainer,
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Text(
                          _isScanComplete ? 'EXTRACTION COMPLETE' : 'PROCESSING',
                          style: AppTypography.labelSm.copyWith(
                            color: _isScanComplete ? AppColors.onSecondaryContainer : AppColors.onTertiaryContainer,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Scanner viewport
                LayoutBuilder(
                  builder: (context, constraints) {
                    final viewHeight = constraints.maxWidth * 3 / 4;
                    return Stack(
                      children: [
                        // Mock certificate image
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Container(
                            color: AppColors.surfaceContainerHigh,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1544816155-12df9643f363?w=800&q=80',
                              fit: BoxFit.cover,
                              opacity: const AlwaysStoppedAnimation(0.65),
                            ),
                          ),
                        ),

                        // OCR Scanning Sweeper Line
                        if (!_isScanComplete)
                          AnimatedBuilder(
                            animation: _scannerController,
                            builder: (context, child) {
                              return Positioned(
                                top: _scannerController.value * (viewHeight - 10), // sweeping offset range
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.transparent, AppColors.secondary, Colors.transparent],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.secondary,
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        // Bounding Box Overlays
                        if (_isFileUploaded) ...[
                          _buildOcrMarker(
                            top: viewHeight * 0.2,
                            left: constraints.maxWidth * 0.1,
                            width: 100,
                            label: 'Carat: 2.05 ct',
                            visible: _isScanComplete || _scannerController.value > 0.2,
                          ),
                          _buildOcrMarker(
                            top: viewHeight * 0.45,
                            right: constraints.maxWidth * 0.1,
                            width: 90,
                            label: 'Clarity: VVS1',
                            visible: _isScanComplete || _scannerController.value > 0.5,
                          ),
                          _buildOcrMarker(
                            bottom: viewHeight * 0.2,
                            left: constraints.maxWidth * 0.2,
                            width: 130,
                            label: 'Report: #6422190874',
                            visible: _isScanComplete || _scannerController.value > 0.8,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOcrMarker({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double width,
    required String label,
    required bool visible,
  }) {
    if (!visible) return const SizedBox.shrink();
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: width,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 9,
            letterSpacing: 0.5,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationColumn(bool isMobile) {
    final cardPadding = isMobile ? 14.0 : 20.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Data Extraction Card
        Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
            side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology_rounded, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Extracted Details',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Grid detail blocks
                Row(
                  children: [
                    Expanded(child: _buildExtractedField('CARAT WEIGHT', _isScanComplete ? '2.05 ct' : '')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildExtractedField('COLOR GRADE', _isScanComplete ? 'D' : '')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildExtractedField('CLARITY', _isScanComplete ? 'VVS1' : '')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildExtractedField('CUT GRADE', _isScanComplete ? 'Excellent' : '')),
                  ],
                ),
                const SizedBox(height: 12),
                _buildExtractedField('REPORT NUMBER', _isScanComplete ? '6422190874' : ''),

                const SizedBox(height: 20),
                Container(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.15)),
                const SizedBox(height: 16),

                // Confidence indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AI Confidence Score', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                    Text(_isScanComplete ? '98.4%' : '0.0%', style: AppTypography.dataMono.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                LayoutBuilder(
                  builder: (context, progressConstraints) {
                    return Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: _isScanComplete ? progressConstraints.maxWidth * 0.98 : 0,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Verification Status Card
        Card(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _isSyncComplete ? Icons.done_all_rounded : Icons.sync_rounded,
                        color: AppColors.onPrimary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Database Verification',
                            style: AppTypography.titleLg.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold, fontSize: isMobile ? 18 : 22),
                          ),
                          Text(
                            _isSyncComplete ? 'GIA Database Synchronized' : 'Syncing with GIA Global API',
                            style: AppTypography.bodySm.copyWith(color: AppColors.onPrimary.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sync milestones
                _buildSyncMilestone('Document Integrity Confirmed', _syncStep1),
                const SizedBox(height: 10),
                _buildSyncMilestone('Serial Match Found', _syncStep2),
                const SizedBox(height: 10),
                _buildSyncMilestone(
                  _syncStep3 ? 'Lab Signatures Authenticated' : 'Authenticating Lab Signatures...',
                  _syncStep3,
                  showSpinner: _syncStep2 && !_syncStep3,
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSyncComplete ? _onFinalize : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.onPrimary,
                      foregroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.onPrimary.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                    ),
                    child: Text(
                      'REVIEW & FINALIZE LISTING',
                      style: AppTypography.labelMd.copyWith(
                        color: _isSyncComplete ? AppColors.primary : AppColors.primary.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),
        // Pro tip guidance card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PRO TIP',
                style: AppTypography.labelSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'High-fidelity certificates increase your buyer trust rating by up to 40%. Ensure your digital copy is high-contrast and blur-free.',
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExtractedField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTypography.labelSm.copyWith(color: AppColors.outline, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
        const SizedBox(height: 6),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.dataMono.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSyncMilestone(String text, bool isChecked, {bool showSpinner = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: isChecked
              ? const Icon(Icons.check_circle_rounded, color: AppColors.secondaryFixedDim, size: 16)
              : showSpinner
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(color: AppColors.onPrimary, strokeWidth: 1.5),
                    )
                  : Icon(Icons.radio_button_unchecked_rounded, color: AppColors.onPrimary.withValues(alpha: 0.4), size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySm.copyWith(
              color: isChecked
                  ? AppColors.onPrimary
                  : showSpinner
                      ? AppColors.onPrimary.withValues(alpha: 0.8)
                      : AppColors.onPrimary.withValues(alpha: 0.45),
              fontWeight: isChecked || showSpinner ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
