/// Represents a single search result item.
///
/// Used for displaying gemstones, jewelry, and other products in search results.
class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.badge,
    this.rating,
    this.reviewCount,
    this.certification,
    this.weight,
    this.cut,
    this.specs,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String? badge;
  final double? rating;
  final int? reviewCount;
  final String? certification;
  final String? weight;
  final String? cut;
  final Map<String, String>? specs;
}
