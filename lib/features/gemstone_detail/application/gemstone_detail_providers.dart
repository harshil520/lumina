import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina/features/gemstone_detail/data/repositories/gemstone_detail_repository_fake.dart';
import 'package:lumina/features/gemstone_detail/domain/models/gemstone_detail.dart';
import 'package:lumina/features/gemstone_detail/domain/repositories/gemstone_detail_repository.dart';

/// Provides the [GemstoneDetailRepository] implementation.
final gemstoneDetailRepositoryProvider =
    Provider<GemstoneDetailRepository>((ref) {
  return GemstoneDetailRepositoryFake();
});

/// Fetches gemstone detail by ID. Uses `.family` for per-item data.
final gemstoneDetailProvider =
    FutureProvider.family<GemstoneDetail, String>((ref, id) {
  return ref.watch(gemstoneDetailRepositoryProvider).getGemstoneDetail(id);
});
