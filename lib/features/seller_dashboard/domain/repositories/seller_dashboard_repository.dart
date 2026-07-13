import '../../../../features/gemstone_detail/domain/models/gemstone_detail.dart';
import '../models/seller_stats.dart';

/// Repository interface for merchant operations and dashboard analytics.
abstract class SellerDashboardRepository {
  /// Fetches merchant dashboard metrics and portfolio valuations.
  Future<SellerStats> getStats();

  /// Retrieves listed gemstone assets currently managed by the merchant.
  Future<List<GemstoneDetail>> getSellerListings();

  /// Submits and registers a new certified gemstone listing to the ledger.
  Future<void> addListing(GemstoneDetail gemstone);

  /// Updates an existing certified gemstone listing.
  Future<void> updateListing(GemstoneDetail gemstone);

  /// Removes a certified gemstone listing by ID.
  Future<void> removeListing(String id);
}
