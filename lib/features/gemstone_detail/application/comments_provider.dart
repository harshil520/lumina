import 'package:flutter_riverpod/flutter_riverpod.dart';

class GemstoneComment {
  const GemstoneComment({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });

  final String id;
  final String authorName;
  final String avatarUrl;
  final double rating;
  final String comment;
  final String date;
}

class GemstoneCommentsNotifier extends FamilyNotifier<List<GemstoneComment>, String> {
  @override
  List<GemstoneComment> build(String arg) {
    // Return initial seed comments for this gemstone ID
    return [
      GemstoneComment(
        id: '1',
        authorName: 'Marcus Aurelius',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
        rating: 5.0,
        comment: 'Absolutely stunning brilliance. The GIA certificate details match perfectly with my independent valuation. Highly secure purchase process.',
        date: '3 days ago',
      ),
      GemstoneComment(
        id: '2',
        authorName: 'Eleanor Vance',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&q=80',
        rating: 4.8,
        comment: 'Slightly slow transit to the vault, but custody confirmation was fully transparent. The cut grade is exceptional.',
        date: '1 week ago',
      ),
    ];
  }

  void addComment(double rating, String commentText) {
    final newComment = GemstoneComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'Alexander Sterling', // default logged-in user
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
      rating: rating,
      comment: commentText,
      date: 'Just now',
    );
    state = [newComment, ...state];
  }
}

final gemstoneCommentsProvider = NotifierProviderFamily<GemstoneCommentsNotifier, List<GemstoneComment>, String>(
  GemstoneCommentsNotifier.new,
);
