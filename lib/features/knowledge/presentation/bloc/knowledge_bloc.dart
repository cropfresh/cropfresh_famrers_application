// ===================================================================
// * KNOWLEDGE BLOC
// * Purpose: State management for Knowledge Hub (KrishiGyan Kendra)
// * Features: Content loading, search, filtering, offline caching
// * Security Level: LOW - Public educational content
// ===================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/knowledge_content.dart';
import '../../domain/repositories/knowledge_repository.dart';

// * KNOWLEDGE EVENTS
abstract class KnowledgeEvent extends Equatable {
  const KnowledgeEvent();

  @override
  List<Object?> get props => [];
}

class LoadKnowledgeContent extends KnowledgeEvent {
  const LoadKnowledgeContent();
}

class RefreshKnowledgeContent extends KnowledgeEvent {
  const RefreshKnowledgeContent();
}

class SearchKnowledgeContent extends KnowledgeEvent {
  final String query;
  final String? category;
  final String? language;

  const SearchKnowledgeContent({
    required this.query,
    this.category,
    this.language,
  });

  @override
  List<Object?> get props => [query, category, language];
}

class FilterKnowledgeByCategory extends KnowledgeEvent {
  final String category;

  const FilterKnowledgeByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class ChangeKnowledgeLanguage extends KnowledgeEvent {
  final String language;

  const ChangeKnowledgeLanguage(this.language);

  @override
  List<Object> get props => [language];
}

class LoadArticleDetails extends KnowledgeEvent {
  final String articleId;

  const LoadArticleDetails(this.articleId);

  @override
  List<Object> get props => [articleId];
}

class LoadVideoDetails extends KnowledgeEvent {
  final String videoId;

  const LoadVideoDetails(this.videoId);

  @override
  List<Object> get props => [videoId];
}

class MarkContentAsRead extends KnowledgeEvent {
  final String contentId;
  final String contentType;

  const MarkContentAsRead({
    required this.contentId,
    required this.contentType,
  });

  @override
  List<Object> get props => [contentId, contentType];
}

class BookmarkContent extends KnowledgeEvent {
  final String contentId;
  final bool isBookmarked;

  const BookmarkContent({
    required this.contentId,
    required this.isBookmarked,
  });

  @override
  List<Object> get props => [contentId, isBookmarked];
}

class DownloadContentForOffline extends KnowledgeEvent {
  final String contentId;

  const DownloadContentForOffline(this.contentId);

  @override
  List<Object> get props => [contentId];
}

// * KNOWLEDGE STATES
abstract class KnowledgeState extends Equatable {
  const KnowledgeState();

  @override
  List<Object?> get props => [];
}

class KnowledgeInitial extends KnowledgeState {
  const KnowledgeInitial();
}

class KnowledgeLoading extends KnowledgeState {
  const KnowledgeLoading();
}

class KnowledgeLoaded extends KnowledgeState {
  final Map<String, dynamic> featuredContent;
  final List<Map<String, dynamic>> articles;
  final List<Map<String, dynamic>> videos;
  final List<Map<String, dynamic>> expertQA;
  final List<Map<String, dynamic>> trendingContent;
  final List<Map<String, dynamic>> recentContent;
  final List<Map<String, dynamic>> bookmarkedContent;
  final String selectedLanguage;
  final String selectedCategory;

  const KnowledgeLoaded({
    required this.featuredContent,
    required this.articles,
    required this.videos,
    required this.expertQA,
    required this.trendingContent,
    required this.recentContent,
    required this.bookmarkedContent,
    this.selectedLanguage = 'Kannada',
    this.selectedCategory = 'All',
  });

  @override
  List<Object?> get props => [
        featuredContent,
        articles,
        videos,
        expertQA,
        trendingContent,
        recentContent,
        bookmarkedContent,
        selectedLanguage,
        selectedCategory,
      ];

  KnowledgeLoaded copyWith({
    Map<String, dynamic>? featuredContent,
    List<Map<String, dynamic>>? articles,
    List<Map<String, dynamic>>? videos,
    List<Map<String, dynamic>>? expertQA,
    List<Map<String, dynamic>>? trendingContent,
    List<Map<String, dynamic>>? recentContent,
    List<Map<String, dynamic>>? bookmarkedContent,
    String? selectedLanguage,
    String? selectedCategory,
  }) {
    return KnowledgeLoaded(
      featuredContent: featuredContent ?? this.featuredContent,
      articles: articles ?? this.articles,
      videos: videos ?? this.videos,
      expertQA: expertQA ?? this.expertQA,
      trendingContent: trendingContent ?? this.trendingContent,
      recentContent: recentContent ?? this.recentContent,
      bookmarkedContent: bookmarkedContent ?? this.bookmarkedContent,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class KnowledgeSearchResults extends KnowledgeState {
  final List<Map<String, dynamic>> searchResults;
  final String query;
  final bool isLoading;

  const KnowledgeSearchResults({
    required this.searchResults,
    required this.query,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [searchResults, query, isLoading];
}

class KnowledgeContentDetail extends KnowledgeState {
  final Map<String, dynamic> content;
  final List<Map<String, dynamic>> relatedContent;
  final bool isBookmarked;
  final bool isDownloaded;

  const KnowledgeContentDetail({
    required this.content,
    required this.relatedContent,
    this.isBookmarked = false,
    this.isDownloaded = false,
  });

  @override
  List<Object> get props => [content, relatedContent, isBookmarked, isDownloaded];
}

class KnowledgeError extends KnowledgeState {
  final String message;
  final String? errorCode;

  const KnowledgeError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class KnowledgeOfflineMode extends KnowledgeState {
  final List<Map<String, dynamic>> cachedContent;
  final String message;

  const KnowledgeOfflineMode({
    required this.cachedContent,
    this.message = 'You are viewing cached content. Connect to internet for latest updates.',
  });

  @override
  List<Object> get props => [cachedContent, message];
}

// * KNOWLEDGE BLOC
class KnowledgeBloc extends Bloc<KnowledgeEvent, KnowledgeState> {
  final KnowledgeRepository _knowledgeRepository;

  KnowledgeBloc({
    required KnowledgeRepository knowledgeRepository,
  })  : _knowledgeRepository = knowledgeRepository,
        super(const KnowledgeInitial()) {
    
    // * Event Handlers
    on<LoadKnowledgeContent>(_onLoadKnowledgeContent);
    on<RefreshKnowledgeContent>(_onRefreshKnowledgeContent);
    on<SearchKnowledgeContent>(_onSearchKnowledgeContent);
    on<FilterKnowledgeByCategory>(_onFilterKnowledgeByCategory);
    on<ChangeKnowledgeLanguage>(_onChangeKnowledgeLanguage);
    on<LoadArticleDetails>(_onLoadArticleDetails);
    on<LoadVideoDetails>(_onLoadVideoDetails);
    on<MarkContentAsRead>(_onMarkContentAsRead);
    on<BookmarkContent>(_onBookmarkContent);
    on<DownloadContentForOffline>(_onDownloadContentForOffline);
  }

  Future<void> _onLoadKnowledgeContent(
    LoadKnowledgeContent event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      emit(const KnowledgeLoading());

      // * Load different types of content in parallel
      final results = await Future.wait([
        _knowledgeRepository.getFeaturedContent(),
        _knowledgeRepository.getArticles(),
        _knowledgeRepository.getVideos(),
        _knowledgeRepository.getExpertQA(),
        _knowledgeRepository.getTrendingContent(),
        _knowledgeRepository.getRecentUpdates(),
        _knowledgeRepository.getBookmarkedContent(),
      ]);

      // ! ALERT: Handle potential null or empty responses
      final featuredContent = results[0] as Map<String, dynamic>? ?? _getDefaultFeaturedContent();
      final articles = results[1] as List<Map<String, dynamic>>? ?? [];
      final videos = results[2] as List<Map<String, dynamic>>? ?? [];
      final expertQA = results[3] as List<Map<String, dynamic>>? ?? [];
      final trendingContent = results[4] as List<Map<String, dynamic>>? ?? [];
      final recentContent = results[5] as List<Map<String, dynamic>>? ?? [];
      final bookmarkedContent = results[6] as List<Map<String, dynamic>>? ?? [];

      emit(KnowledgeLoaded(
        featuredContent: featuredContent,
        articles: articles,
        videos: videos,
        expertQA: expertQA,
        trendingContent: trendingContent,
        recentContent: recentContent,
        bookmarkedContent: bookmarkedContent,
      ));
    } catch (e) {
      // FIXME: Implement proper error handling with user-friendly messages
      emit(KnowledgeError(
        message: 'Failed to load knowledge content: ${e.toString()}',
      ));
    }
  }

  Future<void> _onRefreshKnowledgeContent(
    RefreshKnowledgeContent event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      // * Don't show loading for refresh, keep current state visible
      final currentState = state;
      
      // * Force refresh from network
      await _knowledgeRepository.clearCache();
      
      // * Reload content
      add(const LoadKnowledgeContent());
    } catch (e) {
      emit(KnowledgeError(
        message: 'Failed to refresh knowledge content: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSearchKnowledgeContent(
    SearchKnowledgeContent event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      emit(KnowledgeSearchResults(
        searchResults: [],
        query: event.query,
        isLoading: true,
      ));

      final searchResults = await _knowledgeRepository.searchContent(
        query: event.query,
        category: event.category,
        language: event.language,
      );

      emit(KnowledgeSearchResults(
        searchResults: searchResults,
        query: event.query,
        isLoading: false,
      ));
    } catch (e) {
      emit(KnowledgeError(
        message: 'Search failed: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFilterKnowledgeByCategory(
    FilterKnowledgeByCategory event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      if (state is KnowledgeLoaded) {
        final currentState = state as KnowledgeLoaded;
        
        // * Get filtered content based on category
        final filteredArticles = await _knowledgeRepository.getArticlesByCategory(event.category);
        final filteredVideos = await _knowledgeRepository.getVideosByCategory(event.category);
        
        emit(currentState.copyWith(
          articles: filteredArticles,
          videos: filteredVideos,
          selectedCategory: event.category,
        ));
      }
    } catch (e) {
      emit(KnowledgeError(
        message: 'Failed to filter content: ${e.toString()}',
      ));
    }
  }

  Future<void> _onChangeKnowledgeLanguage(
    ChangeKnowledgeLanguage event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      if (state is KnowledgeLoaded) {
        final currentState = state as KnowledgeLoaded;
        
        // * Update language preference
        await _knowledgeRepository.setLanguagePreference(event.language);
        
        // * Reload content in new language
        add(const LoadKnowledgeContent());
      }
    } catch (e) {
      emit(KnowledgeError(
        message: 'Failed to change language: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadArticleDetails(
    LoadArticleDetails event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      emit(const KnowledgeLoading());

      final results = await Future.wait([
        _knowledgeRepository.getArticleById(event.articleId),
        _knowledgeRepository.getRelatedContent(event.articleId, 'article'),
        _knowledgeRepository.isContentBookmarked(event.articleId),
        _knowledgeRepository.isContentDownloaded(event.articleId),
      ]);

      final content = results[0] as Map<String, dynamic>;
      final relatedContent = results[1] as List<Map<String, dynamic>>;
      final isBookmarked = results[2] as bool;
      final isDownloaded = results[3] as bool;

      // * Mark as read
      await _knowledgeRepository.markAsRead(event.articleId, 'article');

      emit(KnowledgeContentDetail(
        content: content,
        relatedContent: relatedContent,
        isBookmarked: isBookmarked,
        isDownloaded: isDownloaded,
      ));
    } catch (e) {
      emit(KnowledgeError(
        message: 'Failed to load article: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadVideoDetails(
    LoadVideoDetails event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      emit(const KnowledgeLoading());

      final results = await Future.wait([
        _knowledgeRepository.getVideoById(event.videoId),
        _knowledgeRepository.getRelatedContent(event.videoId, 'video'),
        _knowledgeRepository.isContentBookmarked(event.videoId),
        _knowledgeRepository.isContentDownloaded(event.videoId),
      ]);

      final content = results[0] as Map<String, dynamic>;
      final relatedContent = results[1] as List<Map<String, dynamic>>;
      final isBookmarked = results[2] as bool;
      final isDownloaded = results[3] as bool;

      // * Mark as watched
      await _knowledgeRepository.markAsRead(event.videoId, 'video');

      emit(KnowledgeContentDetail(
        content: content,
        relatedContent: relatedContent,
        isBookmarked: isBookmarked,
        isDownloaded: isDownloaded,
      ));
    } catch (e) {
      emit(KnowledgeError(
        message: 'Failed to load video: ${e.toString()}',
      ));
    }
  }

  Future<void> _onMarkContentAsRead(
    MarkContentAsRead event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      await _knowledgeRepository.markAsRead(event.contentId, event.contentType);
      
      // * Update analytics
      await _knowledgeRepository.trackContentEngagement(
        contentId: event.contentId,
        action: 'read',
        contentType: event.contentType,
      );
    } catch (e) {
      // NOTE: Don't emit error state for this, it's not critical
      // TODO: Add logging for analytics tracking failures
    }
  }

  Future<void> _onBookmarkContent(
    BookmarkContent event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      if (event.isBookmarked) {
        await _knowledgeRepository.bookmarkContent(event.contentId);
      } else {
        await _knowledgeRepository.removeBookmark(event.contentId);
      }

      // * Update current state if it's content detail
      if (state is KnowledgeContentDetail) {
        final currentState = state as KnowledgeContentDetail;
        emit(KnowledgeContentDetail(
          content: currentState.content,
          relatedContent: currentState.relatedContent,
          isBookmarked: event.isBookmarked,
          isDownloaded: currentState.isDownloaded,
        ));
      }
    } catch (e) {
      emit(KnowledgeError(
        message: 'Failed to ${event.isBookmarked ? 'bookmark' : 'remove bookmark'}: ${e.toString()}',
      ));
    }
  }

  Future<void> _onDownloadContentForOffline(
    DownloadContentForOffline event,
    Emitter<KnowledgeState> emit,
  ) async {
    try {
      await _knowledgeRepository.downloadForOffline(event.contentId);

      // * Update current state if it's content detail
      if (state is KnowledgeContentDetail) {
        final currentState = state as KnowledgeContentDetail;
        emit(KnowledgeContentDetail(
          content: currentState.content,
          relatedContent: currentState.relatedContent,
          isBookmarked: currentState.isBookmarked,
          isDownloaded: true,
        ));
      }
    } catch (e) {
      emit(KnowledgeError(
        message: 'Failed to download content: ${e.toString()}',
      ));
    }
  }

  // * Helper method to provide default featured content
  Map<String, dynamic> _getDefaultFeaturedContent() {
    return {
      'id': 'default-featured',
      'title': 'Welcome to KrishiGyan Kendra',
      'description': 'Your agricultural knowledge companion. Explore farming techniques, crop care, and expert advice.',
      'category': 'General',
      'type': 'article',
      'readTime': 3,
      'views': 1000,
      'image': null,
    };
  }
} 