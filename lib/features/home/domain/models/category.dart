/// A category card displayed on the home screen (e.g., Natural Diamonds).
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;
}
