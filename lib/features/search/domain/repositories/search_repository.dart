import '../models/search_filter.dart';
import '../models/search_result.dart';

/// Abstract interface for search functionality.
///
/// Providers depend on this — never on the concrete implementation.
/// Swapping the fake for a real API implementation later requires changing
/// only the provider override, not any UI code.
abstract class SearchRepository {
  /// Searches for products with the given query and filters.
  ///
  /// Returns a list of [SearchResult] items matching the search criteria.
  /// The [query] is the user's search text.
  /// The [filter] contains optional filters for category, price, etc.
  /// The [page] is the page number for pagination (1-based).
  /// The [pageSize] is the number of items per page.
  Future<List<SearchResult>> search({
    required String query,
    SearchFilter? filter,
    int page = 1,
    int pageSize = 20,
  });

  /// Gets search suggestions based on the partial query.
  ///
  /// Returns a list of suggested search terms as the user types.
  Future<List<String>> getSuggestions(String query);

  /// Gets popular/trending search terms.
  ///
  /// Returns a list of popular search terms for display when no query is entered.
  Future<List<String>> getPopularSearches();
}
