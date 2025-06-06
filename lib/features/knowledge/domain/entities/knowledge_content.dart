// ===================================================================
// * KNOWLEDGE CONTENT ENTITIES
// * Purpose: Domain entities for agricultural knowledge content
// * Features: Articles, videos, expert Q&A, multimedia content
// * Security Level: LOW - Public educational content models
// ===================================================================

import 'package:equatable/equatable.dart';

// * BASE KNOWLEDGE CONTENT ENTITY
abstract class KnowledgeContent extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String subcategory;
  final List<String> tags;
  final Map<String, String> localizedContent;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int viewCount;
  final double rating;
  final String contentType;
  final bool isOfflineAvailable;
  final String? thumbnailUrl;
  final Map<String, dynamic> metadata;

  const KnowledgeContent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.tags,
    required this.localizedContent,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.updatedAt,
    required this.viewCount,
    required this.rating,
    required this.contentType,
    required this.isOfflineAvailable,
    this.thumbnailUrl,
    required this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        subcategory,
        tags,
        localizedContent,
        authorId,
        authorName,
        createdAt,
        updatedAt,
        viewCount,
        rating,
        contentType,
        isOfflineAvailable,
        thumbnailUrl,
        metadata,
      ];
}

// * ARTICLE ENTITY
class Article extends KnowledgeContent {
  final String content;
  final int readTimeMinutes;
  final List<String> imageUrls;
  final String difficulty;
  final List<String> applicableRegions;
  final List<String> seasonalRelevance;
  final bool isBookmarked;
  final bool isRead;

  const Article({
    required String id,
    required String title,
    required String description,
    required String category,
    required String subcategory,
    required List<String> tags,
    required Map<String, String> localizedContent,
    required String authorId,
    required String authorName,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int viewCount,
    required double rating,
    required bool isOfflineAvailable,
    String? thumbnailUrl,
    required Map<String, dynamic> metadata,
    required this.content,
    required this.readTimeMinutes,
    required this.imageUrls,
    required this.difficulty,
    required this.applicableRegions,
    required this.seasonalRelevance,
    this.isBookmarked = false,
    this.isRead = false,
  }) : super(
          id: id,
          title: title,
          description: description,
          category: category,
          subcategory: subcategory,
          tags: tags,
          localizedContent: localizedContent,
          authorId: authorId,
          authorName: authorName,
          createdAt: createdAt,
          updatedAt: updatedAt,
          viewCount: viewCount,
          rating: rating,
          contentType: 'article',
          isOfflineAvailable: isOfflineAvailable,
          thumbnailUrl: thumbnailUrl,
          metadata: metadata,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        content,
        readTimeMinutes,
        imageUrls,
        difficulty,
        applicableRegions,
        seasonalRelevance,
        isBookmarked,
        isRead,
      ];

  Article copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? subcategory,
    List<String>? tags,
    Map<String, String>? localizedContent,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? viewCount,
    double? rating,
    bool? isOfflineAvailable,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
    String? content,
    int? readTimeMinutes,
    List<String>? imageUrls,
    String? difficulty,
    List<String>? applicableRegions,
    List<String>? seasonalRelevance,
    bool? isBookmarked,
    bool? isRead,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      tags: tags ?? this.tags,
      localizedContent: localizedContent ?? this.localizedContent,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewCount: viewCount ?? this.viewCount,
      rating: rating ?? this.rating,
      isOfflineAvailable: isOfflineAvailable ?? this.isOfflineAvailable,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      metadata: metadata ?? this.metadata,
      content: content ?? this.content,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      imageUrls: imageUrls ?? this.imageUrls,
      difficulty: difficulty ?? this.difficulty,
      applicableRegions: applicableRegions ?? this.applicableRegions,
      seasonalRelevance: seasonalRelevance ?? this.seasonalRelevance,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
    );
  }
}

// * VIDEO ENTITY
class Video extends KnowledgeContent {
  final String videoUrl;
  final String hlsUrl;
  final Duration duration;
  final String quality;
  final List<String> availableQualities;
  final List<VideoChapter> chapters;
  final String? transcriptUrl;
  final bool hasSubtitles;
  final Map<String, String> subtitleUrls;
  final bool isBookmarked;
  final bool isWatched;
  final Duration? watchProgress;

  const Video({
    required String id,
    required String title,
    required String description,
    required String category,
    required String subcategory,
    required List<String> tags,
    required Map<String, String> localizedContent,
    required String authorId,
    required String authorName,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int viewCount,
    required double rating,
    required bool isOfflineAvailable,
    String? thumbnailUrl,
    required Map<String, dynamic> metadata,
    required this.videoUrl,
    required this.hlsUrl,
    required this.duration,
    required this.quality,
    required this.availableQualities,
    required this.chapters,
    this.transcriptUrl,
    required this.hasSubtitles,
    required this.subtitleUrls,
    this.isBookmarked = false,
    this.isWatched = false,
    this.watchProgress,
  }) : super(
          id: id,
          title: title,
          description: description,
          category: category,
          subcategory: subcategory,
          tags: tags,
          localizedContent: localizedContent,
          authorId: authorId,
          authorName: authorName,
          createdAt: createdAt,
          updatedAt: updatedAt,
          viewCount: viewCount,
          rating: rating,
          contentType: 'video',
          isOfflineAvailable: isOfflineAvailable,
          thumbnailUrl: thumbnailUrl,
          metadata: metadata,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        videoUrl,
        hlsUrl,
        duration,
        quality,
        availableQualities,
        chapters,
        transcriptUrl,
        hasSubtitles,
        subtitleUrls,
        isBookmarked,
        isWatched,
        watchProgress,
      ];

  Video copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? subcategory,
    List<String>? tags,
    Map<String, String>? localizedContent,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? viewCount,
    double? rating,
    bool? isOfflineAvailable,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
    String? videoUrl,
    String? hlsUrl,
    Duration? duration,
    String? quality,
    List<String>? availableQualities,
    List<VideoChapter>? chapters,
    String? transcriptUrl,
    bool? hasSubtitles,
    Map<String, String>? subtitleUrls,
    bool? isBookmarked,
    bool? isWatched,
    Duration? watchProgress,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      tags: tags ?? this.tags,
      localizedContent: localizedContent ?? this.localizedContent,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewCount: viewCount ?? this.viewCount,
      rating: rating ?? this.rating,
      isOfflineAvailable: isOfflineAvailable ?? this.isOfflineAvailable,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      metadata: metadata ?? this.metadata,
      videoUrl: videoUrl ?? this.videoUrl,
      hlsUrl: hlsUrl ?? this.hlsUrl,
      duration: duration ?? this.duration,
      quality: quality ?? this.quality,
      availableQualities: availableQualities ?? this.availableQualities,
      chapters: chapters ?? this.chapters,
      transcriptUrl: transcriptUrl ?? this.transcriptUrl,
      hasSubtitles: hasSubtitles ?? this.hasSubtitles,
      subtitleUrls: subtitleUrls ?? this.subtitleUrls,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isWatched: isWatched ?? this.isWatched,
      watchProgress: watchProgress ?? this.watchProgress,
    );
  }
}

// * VIDEO CHAPTER ENTITY
class VideoChapter extends Equatable {
  final String id;
  final String title;
  final Duration startTime;
  final Duration endTime;
  final String? thumbnailUrl;

  const VideoChapter({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, title, startTime, endTime, thumbnailUrl];
}

// * EXPERT Q&A ENTITY
class ExpertQA extends KnowledgeContent {
  final String question;
  final String answer;
  final String expertId;
  final String expertName;
  final String expertTitle;
  final String expertCredentials;
  final String? expertPhotoUrl;
  final DateTime questionAskedAt;
  final DateTime answeredAt;
  final int upvotes;
  final int downvotes;
  final List<String> relatedQuestions;
  final bool isVerified;
  final String status; // 'pending', 'answered', 'verified'

  const ExpertQA({
    required String id,
    required String title,
    required String description,
    required String category,
    required String subcategory,
    required List<String> tags,
    required Map<String, String> localizedContent,
    required String authorId,
    required String authorName,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int viewCount,
    required double rating,
    required bool isOfflineAvailable,
    String? thumbnailUrl,
    required Map<String, dynamic> metadata,
    required this.question,
    required this.answer,
    required this.expertId,
    required this.expertName,
    required this.expertTitle,
    required this.expertCredentials,
    this.expertPhotoUrl,
    required this.questionAskedAt,
    required this.answeredAt,
    required this.upvotes,
    required this.downvotes,
    required this.relatedQuestions,
    required this.isVerified,
    required this.status,
  }) : super(
          id: id,
          title: title,
          description: description,
          category: category,
          subcategory: subcategory,
          tags: tags,
          localizedContent: localizedContent,
          authorId: authorId,
          authorName: authorName,
          createdAt: createdAt,
          updatedAt: updatedAt,
          viewCount: viewCount,
          rating: rating,
          contentType: 'expert_qa',
          isOfflineAvailable: isOfflineAvailable,
          thumbnailUrl: thumbnailUrl,
          metadata: metadata,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        question,
        answer,
        expertId,
        expertName,
        expertTitle,
        expertCredentials,
        expertPhotoUrl,
        questionAskedAt,
        answeredAt,
        upvotes,
        downvotes,
        relatedQuestions,
        isVerified,
        status,
      ];
}

// * KNOWLEDGE CATEGORY ENTITY
class KnowledgeCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String color;
  final List<String> subcategories;
  final int contentCount;
  final Map<String, String> localizedNames;

  const KnowledgeCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.color,
    required this.subcategories,
    required this.contentCount,
    required this.localizedNames,
  });

  @override
  List<Object> get props => [
        id,
        name,
        description,
        iconUrl,
        color,
        subcategories,
        contentCount,
        localizedNames,
      ];
}

// * EXPERT PROFILE ENTITY
class ExpertProfile extends Equatable {
  final String id;
  final String name;
  final String title;
  final String bio;
  final String credentials;
  final String institution;
  final String photoUrl;
  final List<String> specializations;
  final int experienceYears;
  final double rating;
  final int totalAnswers;
  final int verifiedAnswers;
  final List<String> awards;
  final Map<String, String> socialLinks;

  const ExpertProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.credentials,
    required this.institution,
    required this.photoUrl,
    required this.specializations,
    required this.experienceYears,
    required this.rating,
    required this.totalAnswers,
    required this.verifiedAnswers,
    required this.awards,
    required this.socialLinks,
  });

  @override
  List<Object> get props => [
        id,
        name,
        title,
        bio,
        credentials,
        institution,
        photoUrl,
        specializations,
        experienceYears,
        rating,
        totalAnswers,
        verifiedAnswers,
        awards,
        socialLinks,
      ];
}

// * SEARCH RESULT ENTITY
class KnowledgeSearchResult extends Equatable {
  final String id;
  final String title;
  final String description;
  final String contentType;
  final String category;
  final String? thumbnailUrl;
  final double relevanceScore;
  final String snippet;
  final Map<String, dynamic> highlights;

  const KnowledgeSearchResult({
    required this.id,
    required this.title,
    required this.description,
    required this.contentType,
    required this.category,
    this.thumbnailUrl,
    required this.relevanceScore,
    required this.snippet,
    required this.highlights,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        contentType,
        category,
        thumbnailUrl,
        relevanceScore,
        snippet,
        highlights,
      ];
}

// * BOOKMARK ENTITY
class Bookmark extends Equatable {
  final String id;
  final String contentId;
  final String contentType;
  final String userId;
  final DateTime bookmarkedAt;
  final List<String> tags;
  final String? notes;

  const Bookmark({
    required this.id,
    required this.contentId,
    required this.contentType,
    required this.userId,
    required this.bookmarkedAt,
    required this.tags,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        contentId,
        contentType,
        userId,
        bookmarkedAt,
        tags,
        notes,
      ];
} 