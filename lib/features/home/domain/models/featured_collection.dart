/// A featured collection card for the home carousel.
class FeaturedCollection {
  const FeaturedCollection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.actionLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String actionLabel;
}
