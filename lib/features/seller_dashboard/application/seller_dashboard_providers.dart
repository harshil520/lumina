import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/gemstone_detail/domain/models/gemstone_detail.dart';
import '../data/repositories/seller_dashboard_repository_fake.dart';
import '../domain/models/seller_stats.dart';
import '../domain/repositories/seller_dashboard_repository.dart';

/// Provider for the singleton [SellerDashboardRepository].
final sellerDashboardRepositoryProvider = Provider<SellerDashboardRepository>((ref) {
  return SellerDashboardRepositoryFake();
});

/// Notifier to manage the active listings list.
class SellerListingsNotifier extends AsyncNotifier<List<GemstoneDetail>> {
  @override
  Future<List<GemstoneDetail>> build() async {
    return ref.read(sellerDashboardRepositoryProvider).getSellerListings();
  }

  /// Adds a new certified gemstone listing to the ledger and updates state.
  Future<void> addNewListing(GemstoneDetail gemstone) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sellerDashboardRepositoryProvider);
      await repository.addListing(gemstone);
      return repository.getSellerListings();
    });
  }

  /// Updates an existing certified gemstone listing.
  Future<void> updateListing(GemstoneDetail gemstone) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sellerDashboardRepositoryProvider);
      await repository.updateListing(gemstone);
      return repository.getSellerListings();
    });
  }

  /// Removes a certified gemstone listing from the inventory.
  Future<void> removeListing(String gemstoneId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sellerDashboardRepositoryProvider);
      await repository.removeListing(gemstoneId);
      return repository.getSellerListings();
    });
  }
}

/// Provider for the active listings.
final sellerListingsProvider = AsyncNotifierProvider<SellerListingsNotifier, List<GemstoneDetail>>(
  SellerListingsNotifier.new,
);

/// Provider for merchant dashboard statistics.
///
/// Watches [sellerListingsProvider] so that metrics recalculate automatically
/// when new gemstones are listed, updated, or removed.
final sellerStatsProvider = FutureProvider<SellerStats>((ref) async {
  ref.watch(sellerListingsProvider);
  return ref.read(sellerDashboardRepositoryProvider).getStats();
});
