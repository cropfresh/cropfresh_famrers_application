// ===================================================================
// * KNOWLEDGE REPOSITORY INTERFACE
// * Purpose: Repository contract for knowledge hub data operations
// * Features: Content CRUD, search, caching, offline support
// * Security Level: LOW - Public educational content access
// ===================================================================

import '../entities/knowledge_content.dart';

abstract class KnowledgeRepository {
  // * CONTENT RETRIEVAL METHODS
  
  /// Get featured content for the main page
  Future<Map<String, dynamic>> getFeaturedContent();
  
  /// Get all articles with optional filtering
  Future<List<Map<String, dynamic>>> getArticles({
    String? category,
    String? language,
    int? limit,
    int? offset,
  });
  
  /// Get all videos with optional filtering
  Future<List<Map<String, dynamic>>> getVideos({
    String? category,
    String? language,
    int? limit,
    int? offset,
  });
  
  /// Get expert Q&A content
  Future<List<Map<String, dynamic>>> getExpertQA({
    String? category,
    String? expertId,
    int? limit,
    int? offset,
  });
  
  /// Get trending content
  Future<List<Map<String, dynamic>>> getTrendingContent({
    String? timeframe = 'week',
    int? limit = 10,
  });
  
  /// Get recent updates
  Future<List<Map<String, dynamic>>> getRecentUpdates({
    int? limit = 10,
  });
  
  /// Get bookmarked content for current user
  Future<List<Map<String, dynamic>>> getBookmarkedContent();
  
  // * CATEGORY AND FILTERING METHODS
  
  /// Get all available categories
  Future<List<KnowledgeCategory>> getCategories();
  
  /// Get articles by specific category
  Future<List<Map<String, dynamic>>> getArticlesByCategory(String category);
  
  /// Get videos by specific category
  Future<List<Map<String, dynamic>>> getVideosByCategory(String category);
  
  /// Get content by difficulty level
  Future<List<Map<String, dynamic>>> getContentByDifficulty(String difficulty);
  
  /// Get content by seasonal relevance
  Future<List<Map<String, dynamic>>> getSeasonalContent(String season);
  
  // * DETAILED CONTENT METHODS
  
  /// Get article by ID with full content
  Future<Map<String, dynamic>> getArticleById(String articleId);
  
  /// Get video by ID with full details
  Future<Map<String, dynamic>> getVideoById(String videoId);
  
  /// Get expert Q&A by ID
  Future<Map<String, dynamic>> getExpertQAById(String qaId);
  
  /// Get related content based on content ID and type
  Future<List<Map<String, dynamic>>> getRelatedContent(
    String contentId,
    String contentType, {
    int? limit = 5,
  });
  
  // * SEARCH METHODS
  
  /// Search content across all types
  Future<List<Map<String, dynamic>>> searchContent({
    required String query,
    String? category,
    String? contentType,
    String? language,
    int? limit,
    int? offset,
  });
  
  /// Get search suggestions
  Future<List<String>> getSearchSuggestions(String query);
  
  /// Get popular search terms
  Future<List<String>> getPopularSearchTerms();
  
  // * USER INTERACTION METHODS
  
  /// Mark content as read/watched
  Future<void> markAsRead(String contentId, String contentType);
  
  /// Check if content is bookmarked
  Future<bool> isContentBookmarked(String contentId);
  
  /// Bookmark content
  Future<void> bookmarkContent(String contentId);
  
  /// Remove bookmark
  Future<void> removeBookmark(String contentId);
  
  /// Rate content
  Future<void> rateContent(String contentId, double rating);
  
  /// Submit feedback
  Future<void> submitFeedback(String contentId, String feedback);
  
  // * EXPERT METHODS
  
  /// Get expert profiles
  Future<List<ExpertProfile>> getExperts({
    String? specialization,
    int? limit,
  });
  
  /// Get expert by ID
  Future<ExpertProfile> getExpertById(String expertId);
  
  /// Ask a question to experts
  Future<String> askQuestion({
    required String question,
    required String category,
    String? expertId,
  });
  
  /// Get user's questions
  Future<List<Map<String, dynamic>>> getUserQuestions();
  
  // * OFFLINE AND CACHING METHODS
  
  /// Download content for offline access
  Future<void> downloadForOffline(String contentId);
  
  /// Check if content is downloaded
  Future<bool> isContentDownloaded(String contentId);
  
  /// Get downloaded content
  Future<List<Map<String, dynamic>>> getDownloadedContent();
  
  /// Remove downloaded content
  Future<void> removeDownloadedContent(String contentId);
  
  /// Clear all cache
  Future<void> clearCache();
  
  /// Update cache with fresh data
  Future<void> refreshCache();
  
  // * ANALYTICS AND TRACKING METHODS
  
  /// Track content engagement
  Future<void> trackContentEngagement({
    required String contentId,
    required String action, // 'view', 'read', 'watch', 'share', 'download'
    required String contentType,
    Duration? duration,
    Map<String, dynamic>? additionalData,
  });
  
  /// Track search queries
  Future<void> trackSearchQuery(String query, int resultCount);
  
  /// Get user reading statistics
  Future<Map<String, dynamic>> getUserReadingStats();
  
  // * PREFERENCES METHODS
  
  /// Set language preference
  Future<void> setLanguagePreference(String language);
  
  /// Get language preference
  Future<String> getLanguagePreference();
  
  /// Set notification preferences
  Future<void> setNotificationPreferences(Map<String, bool> preferences);
  
  /// Get notification preferences
  Future<Map<String, bool>> getNotificationPreferences();
  
  // * CONTENT MANAGEMENT METHODS (for admin/moderator features)
  
  /// Report content
  Future<void> reportContent(String contentId, String reason);
  
  /// Submit content suggestion
  Future<void> submitContentSuggestion({
    required String title,
    required String description,
    required String category,
    String? additionalInfo,
  });
  
  /// Get content recommendations based on user behavior
  Future<List<Map<String, dynamic>>> getPersonalizedRecommendations({
    int? limit = 10,
  });
  
  // * SOCIAL FEATURES
  
  /// Share content
  Future<String> shareContent(String contentId, String platform);
  
  /// Get sharing statistics
  Future<Map<String, int>> getContentSharingStats(String contentId);
  
  /// Vote on expert answers
  Future<void> voteOnAnswer(String answerId, bool isUpvote);
  
  /// Comment on content
  Future<void> commentOnContent(String contentId, String comment);
  
  /// Get comments for content
  Future<List<Map<String, dynamic>>> getContentComments(String contentId);
  
  // * SUBSCRIPTION AND NOTIFICATIONS
  
  /// Subscribe to category updates
  Future<void> subscribeToCategoryUpdates(String category);
  
  /// Unsubscribe from category updates
  Future<void> unsubscribeFromCategoryUpdates(String category);
  
  /// Get subscribed categories
  Future<List<String>> getSubscribedCategories();
  
  /// Get new content notifications
  Future<List<Map<String, dynamic>>> getNewContentNotifications();
  
  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId);
} 