import '../../../../features/gemstone_detail/data/repositories/gemstone_detail_repository_fake.dart';
import '../../../../features/gemstone_detail/domain/models/gemstone_detail.dart';
import '../../domain/models/seller_stats.dart';
import '../../domain/repositories/seller_dashboard_repository.dart';

/// Fake implementation of [SellerDashboardRepository] backed by the global gemstone database.
class SellerDashboardRepositoryFake implements SellerDashboardRepository {
  @override
  Future<SellerStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const SellerStats(
      totalValue: 842500.00,
      activeListings: 142,
      monthlyVolume: 842500.00,
      volumeIncreasePercent: 12.4,
      pendingEscrows: 18,
    );
  }

  @override
  Future<List<GemstoneDetail>> getSellerListings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sterlingListings = GemstoneDetailRepositoryFake.dummyData.values
        .where((stone) => stone.seller.name == 'Alexander Sterling')
        .toList();
    // Return sorted or in order
    return sterlingListings;
  }

  @override
  Future<void> addListing(GemstoneDetail gemstone) async {
    await Future.delayed(const Duration(milliseconds: 600));
    GemstoneDetailRepositoryFake.addGemstone(gemstone);
  }

  @override
  Future<void> updateListing(GemstoneDetail gemstone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    GemstoneDetailRepositoryFake.updateGemstone(gemstone);
  }

  @override
  Future<void> removeListing(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    GemstoneDetailRepositoryFake.removeGemstone(id);
  }
}
