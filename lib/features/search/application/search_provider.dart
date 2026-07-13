import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/search_repository_fake.dart';
import '../domain/models/search_filter.dart';
import '../domain/models/search_result.dart';
import '../domain/repositories/search_repository.dart';

/// Provides the [SearchRepository] implementation.
///
/// Swap [SearchRepositoryFake] for the real implementation when the API is ready.
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryFake();
});

/// Notifier for managing search state with debounce.
///
/// Handles search queries, filters, pagination, and suggestions.
class SearchNotifier extends AsyncNotifier<SearchState> {
  Timer? _debounceTimer;
  String _currentQuery = '';
  SearchFilter _currentFilter = const SearchFilter();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<SearchState> build() async {
    // Initialize with popular searches and default results
    final popularSearches = await ref.read(searchRepositoryProvider).getPopularSearches();
    final defaultResults = await ref.read(searchRepositoryProvider).search(query: '');
    return SearchState(
      results: defaultResults,
      suggestions: [],
      popularSearches: popularSearches,
      query: '',
      filter: const SearchFilter(),
      hasMore: false,
      isLoading: false,
    );
  }

  /// Updates the search query with debounce.
  ///
  /// Debounces the search by 300ms to avoid spamming the API on every keystroke.
  void updateQuery(String query) {
    _currentQuery = query;
    _currentPage = 1;
    _hasMore = true;

    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      // If query is empty, reset to initial state
      _fetchPopularSearches();
      return;
    }

    // Set loading state
    state = AsyncData(state.valueOrNull?.copyWith(
      isLoading: true,
      query: query,
    ) ?? SearchState(
      results: [],
      suggestions: [],
      popularSearches: [],
      query: query,
      filter: _currentFilter,
      hasMore: false,
      isLoading: true,
    ));

    // Debounce the search
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query, _currentFilter, resetResults: true);
    });
  }

  /// Updates search suggestions as user types.
  void updateSuggestions(String query) async {
    if (query.isEmpty) {
      state = AsyncData(state.valueOrNull?.copyWith(suggestions: []) ?? SearchState(
        results: [],
        suggestions: [],
        popularSearches: state.valueOrNull?.popularSearches ?? [],
        query: '',
        filter: _currentFilter,
        hasMore: false,
        isLoading: false,
      ));
      return;
    }

    final suggestions = await ref.read(searchRepositoryProvider).getSuggestions(query);
    state = AsyncData(state.valueOrNull?.copyWith(suggestions: suggestions) ?? SearchState(
      results: [],
      suggestions: suggestions,
      popularSearches: state.valueOrNull?.popularSearches ?? [],
      query: query,
      filter: _currentFilter,
      hasMore: false,
      isLoading: false,
    ));
  }

  /// Applies a filter and performs a new search.
  void applyFilter(SearchFilter filter) {
    _currentFilter = filter;
    _currentPage = 1;
    _hasMore = true;
    _performSearch(_currentQuery, filter, resetResults: true);
  }

  /// Clears all filters and performs a new search.
  void clearFilters() {
    _currentFilter = const SearchFilter();
    _currentPage = 1;
    _hasMore = true;
    _performSearch(_currentQuery, _currentFilter, resetResults: true);
  }

  /// Loads the next page of results.
  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasMore || _currentQuery.isEmpty) return;

    _isLoadingMore = true;
    _currentPage++;

    final results = await ref.read(searchRepositoryProvider).search(
      query: _currentQuery,
      filter: _currentFilter,
      page: _currentPage,
    );

    if (results.isEmpty) {
      _hasMore = false;
    } else {
      final currentResults = state.valueOrNull?.results ?? [];
      state = AsyncData(state.valueOrNull?.copyWith(
        results: [...currentResults, ...results],
        hasMore: results.length >= 20,
        isLoading: false,
      ) ?? SearchState(
        results: results,
        suggestions: [],
        popularSearches: [],
        query: _currentQuery,
        filter: _currentFilter,
        hasMore: results.length >= 20,
        isLoading: false,
      ));
    }

    _isLoadingMore = false;
  }

  /// Performs the actual search.
  void _performSearch(String query, SearchFilter filter, {bool resetResults = false}) async {
    if (query.isEmpty) {
      _fetchPopularSearches();
      return;
    }

    state = AsyncData(state.valueOrNull?.copyWith(
      isLoading: true,
      query: query,
      filter: filter,
    ) ?? SearchState(
      results: [],
      suggestions: [],
      popularSearches: [],
      query: query,
      filter: filter,
      hasMore: false,
      isLoading: true,
    ));

    final results = await ref.read(searchRepositoryProvider).search(
      query: query,
      filter: filter,
      page: 1,
    );

    state = AsyncData(SearchState(
      results: resetResults ? results : (state.valueOrNull?.results ?? []) + results,
      suggestions: [],
      popularSearches: state.valueOrNull?.popularSearches ?? [],
      query: query,
      filter: filter,
      hasMore: results.length >= 20,
      isLoading: false,
    ));
  }

  /// Fetches popular searches when no query is entered.
  void _fetchPopularSearches() async {
    final popularSearches = await ref.read(searchRepositoryProvider).getPopularSearches();
    final defaultResults = await ref.read(searchRepositoryProvider).search(query: '', filter: _currentFilter);
    state = AsyncData(SearchState(
      results: defaultResults,
      suggestions: [],
      popularSearches: popularSearches,
      query: '',
      filter: _currentFilter,
      hasMore: false,
      isLoading: false,
    ));
  }

  /// Clears the current search.
  void clearSearch() {
    _currentQuery = '';
    _currentFilter = const SearchFilter();
    _currentPage = 1;
    _hasMore = true;
    _debounceTimer?.cancel();
    _fetchPopularSearches();
  }

  /// Cancels any pending debounce timer.
  void cancelPendingSearch() {
    _debounceTimer?.cancel();
  }
}

/// State class for search functionality.
class SearchState {
  const SearchState({
    required this.results,
    required this.suggestions,
    required this.popularSearches,
    required this.query,
    required this.filter,
    required this.hasMore,
    required this.isLoading,
  });

  final List<SearchResult> results;
  final List<String> suggestions;
  final List<String> popularSearches;
  final String query;
  final SearchFilter filter;
  final bool hasMore;
  final bool isLoading;

  SearchState copyWith({
    List<SearchResult>? results,
    List<String>? suggestions,
    List<String>? popularSearches,
    String? query,
    SearchFilter? filter,
    bool? hasMore,
    bool? isLoading,
  }) {
    return SearchState(
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      popularSearches: popularSearches ?? this.popularSearches,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider for the search notifier.
final searchProvider = AsyncNotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);
