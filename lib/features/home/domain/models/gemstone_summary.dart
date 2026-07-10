/// Summary model for a gemstone displayed in trending/product grids.
class GemstoneSummary {
  const GemstoneSummary({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.certificationBadge,
    required this.weight,
    required this.cut,
    required this.price,
    this.isFavorited = false,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String certificationBadge;
  final String weight;
  final String cut;
  final double price;
  final bool isFavorited;
}
