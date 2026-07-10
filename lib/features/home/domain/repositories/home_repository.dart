import '../models/category.dart';
import '../models/featured_collection.dart';
import '../models/gemstone_summary.dart';

/// Abstract interface for home screen data.
///
/// Providers depend on this — never on the concrete implementation.
/// Swapping the fake for a real API implementation later requires changing
/// only the provider override, not any UI code.
abstract class HomeRepository {
  /// Fetches the list of shop-by-category items.
  Future<List<Category>> getCategories();

  /// Fetches featured collections for the horizontal carousel.
  Future<List<FeaturedCollection>> getFeaturedCollections();

  /// Fetches trending gemstones for the product grid.
  Future<List<GemstoneSummary>> getTrendingGemstones();
}
