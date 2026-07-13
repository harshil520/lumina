/// Represents search filters for refining search results.
///
/// Used for filtering by category, price range, carat range, cut, and certification.
class SearchFilter {
  const SearchFilter({
    this.productCategory = 'Diamonds',
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minCarat,
    this.maxCarat,
    this.certification,
    this.cut,
    this.sortBy,
    this.gemstoneType,
    this.origin,
    this.treatment,
    this.jewelryType,
    this.metal,
    this.settingType,
  });

  final String productCategory;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minCarat;
  final double? maxCarat;
  final String? certification;
  final String? cut;
  final SearchSortBy? sortBy;
  final String? gemstoneType;
  final String? origin;
  final String? treatment;
  final String? jewelryType;
  final String? metal;
  final String? settingType;

  SearchFilter copyWith({
    String? productCategory,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minCarat,
    double? maxCarat,
    String? certification,
    String? cut,
    SearchSortBy? sortBy,
    String? gemstoneType,
    String? origin,
    String? treatment,
    String? jewelryType,
    String? metal,
    String? settingType,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinCarat = false,
    bool clearMaxCarat = false,
    bool clearCertification = false,
    bool clearCut = false,
    bool clearGemstoneType = false,
    bool clearOrigin = false,
    bool clearTreatment = false,
    bool clearJewelryType = false,
    bool clearMetal = false,
    bool clearSettingType = false,
  }) {
    return SearchFilter(
      productCategory: productCategory ?? this.productCategory,
      category: category ?? this.category,
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minCarat: clearMinCarat ? null : (minCarat ?? this.minCarat),
      maxCarat: clearMaxCarat ? null : (maxCarat ?? this.maxCarat),
      certification: clearCertification ? null : (certification ?? this.certification),
      cut: clearCut ? null : (cut ?? this.cut),
      sortBy: sortBy ?? this.sortBy,
      gemstoneType: clearGemstoneType ? null : (gemstoneType ?? this.gemstoneType),
      origin: clearOrigin ? null : (origin ?? this.origin),
      treatment: clearTreatment ? null : (treatment ?? this.treatment),
      jewelryType: clearJewelryType ? null : (jewelryType ?? this.jewelryType),
      metal: clearMetal ? null : (metal ?? this.metal),
      settingType: clearSettingType ? null : (settingType ?? this.settingType),
    );
  }
}

/// Sorting options for search results.
enum SearchSortBy {
  relevance('Relevance'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  caratLowToHigh('Carat: Low to High'),
  caratHighToLow('Carat: High to Low'),
  clarity('Clarity: Best First'),
  rating('Rating'),
  newest('Newest');

  const SearchSortBy(this.label);
  final String label;
}
