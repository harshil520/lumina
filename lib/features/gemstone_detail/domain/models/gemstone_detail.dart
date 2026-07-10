/// Full detail model for a gemstone including 4Cs, technical specs, seller info.
class GemstoneDetail {
  const GemstoneDetail({
    required this.id,
    required this.name,
    required this.collectionLabel,
    required this.price,
    required this.imageUrls,
    required this.certificationBadge,
    required this.caratWeight,
    required this.colorGrade,
    required this.clarityGrade,
    required this.cutGrade,
    required this.polish,
    required this.symmetry,
    required this.fluorescence,
    required this.giaReportNumber,
    required this.description,
    required this.seller,
    required this.similarStoneIds,
  });

  final String id;
  final String name;
  final String collectionLabel;
  final double price;
  final List<String> imageUrls;
  final String certificationBadge;

  // The 4Cs
  final String caratWeight;
  final String colorGrade;
  final String clarityGrade;
  final String cutGrade;

  // Technical details
  final String polish;
  final String symmetry;
  final String fluorescence;
  final String giaReportNumber;

  final String description;
  final SellerInfo seller;
  final List<String> similarStoneIds;
}

/// Seller profile displayed on the gemstone detail screen.
class SellerInfo {
  const SellerInfo({
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.reviewCount,
    required this.tagline,
  });

  final String name;
  final String avatarUrl;
  final double rating;
  final int reviewCount;
  final String tagline;
}
