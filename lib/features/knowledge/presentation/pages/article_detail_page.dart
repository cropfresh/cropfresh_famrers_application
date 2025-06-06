import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// * ARTICLE DETAIL PAGE
/// * Displays detailed agricultural knowledge articles
/// * Supports multiple languages and rich content display
class ArticleDetailPage extends StatefulWidget {
  final String articleId;

  const ArticleDetailPage({
    super.key,
    required this.articleId,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool _isBookmarked = false;
  bool _isLiked = false;
  int _likes = 42;

  // * Sample article data - will be replaced with actual API data
  final Map<String, dynamic> _article = {
    'title': 'Organic Pest Control Methods for Tomato Farming',
    'author': 'Dr. Rajesh Kumar',
    'authorCredentials': 'PhD in Agricultural Sciences',
    'institution': 'University of Agricultural Sciences, Bangalore',
    'publishDate': '2024-01-15',
    'readTime': '5 min read',
    'category': 'Pest Management',
    'tags': ['Organic', 'Tomato', 'Pest Control', 'Sustainable'],
    'content': '''
Organic pest control is essential for sustainable tomato farming. Here are proven methods to protect your tomato crops naturally:

**1. Companion Planting**
Plant basil, marigolds, and nasturtiums near your tomato plants. These companion plants naturally repel common tomato pests like aphids and whiteflies.

**2. Neem Oil Treatment**
Apply neem oil spray every 7-10 days during the growing season. Mix 2ml of neem oil per liter of water and spray during early morning or late evening.

**3. Beneficial Insects**
Encourage ladybugs, lacewings, and praying mantises in your garden. These natural predators help control harmful pests.

**4. Physical Barriers**
Use row covers or fine mesh to protect young plants from flying insects and small pests.

**5. Organic Sprays**
Create homemade sprays using garlic, soap solution, or chili pepper extracts. These are effective against soft-bodied insects.

**Prevention Tips:**
- Maintain proper spacing between plants
- Ensure good air circulation
- Remove infected plants immediately
- Practice crop rotation

Remember, consistency is key in organic pest management. Regular monitoring and early intervention are crucial for success.
    ''',
    'images': [
      'https://example.com/tomato-farm.jpg',
      'https://example.com/neem-spray.jpg',
      'https://example.com/companion-plants.jpg',
    ],
    'relatedArticles': [
      'Soil Health for Tomato Cultivation',
      'Water Management in Vegetable Farming',
      'Harvesting and Post-Harvest Care',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: CustomAppBar(
        title: 'Article',
        backgroundColor: CropFreshColors.orange10Primary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _toggleBookmark(),
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => _shareArticle(),
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Article Header
            _buildArticleHeader(),
            
            // * Article Content
            _buildArticleContent(),
            
            // * Article Actions
            _buildArticleActions(),
            
            // * Related Articles
            _buildRelatedArticles(),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Category and Read Time
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: CropFreshColors.green30Container,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _article['category'],
                  style: TextStyle(
                    fontSize: 12,
                                          color: CropFreshColors.green30Primary,
                      fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _article['readTime'],
                style: TextStyle(
                  fontSize: 12,
                  color: CropFreshColors.onBackground60Secondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // * Article Title
          Text(
            _article['title'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // * Author Information
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: CropFreshColors.green30Primary,
                child: Text(
                  _article['author'].substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _article['author'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _article['authorCredentials'],
                      style: TextStyle(
                        fontSize: 12,
                        color: CropFreshColors.onBackground60Secondary,
                      ),
                    ),
                    Text(
                      _article['institution'],
                      style: TextStyle(
                        fontSize: 12,
                        color: CropFreshColors.onBackground60Tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // * Publish Date and Tags
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Published on ${_article['publishDate']}',
                style: TextStyle(
                  fontSize: 12,
                  color: CropFreshColors.onBackground60Secondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // * Tags
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _article['tags'].map<Widget>((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: CropFreshColors.background60Container,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Featured Image (placeholder)
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: CropFreshColors.green30Container,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.image,
              size: 48,
              color: CropFreshColors.green30Primary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // * Article Content
          Text(
            _article['content'],
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleActions() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // * Like Button
          InkWell(
            onTap: () => _toggleLike(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: _isLiked 
                    ? CropFreshColors.green30Container
                    : CropFreshColors.background60Container,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 16,
                    color: _isLiked 
                        ? CropFreshColors.green30Primary
                        : CropFreshColors.onBackground60Secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$_likes',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isLiked 
                          ? CropFreshColors.green30Primary
                          : CropFreshColors.onBackground60Secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // * Comment Button
          InkWell(
            onTap: () => _showComments(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: CropFreshColors.background60Container,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Comment',
                    style: TextStyle(
                      fontSize: 14,
                      color: CropFreshColors.onBackground60Secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // * Download Button
          InkWell(
            onTap: () => _downloadArticle(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: CropFreshColors.green30Primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Download',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticles() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Articles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          ..._article['relatedArticles'].map<Widget>((article) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  // TODO: Navigate to related article
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.article,
                        size: 16,
                        color: CropFreshColors.green30Primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          article,
                          style: TextStyle(
                            fontSize: 14,
                            color: CropFreshColors.green30Primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked 
              ? 'Article bookmarked' 
              : 'Bookmark removed',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
  }

  void _shareArticle() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showComments() {
    // TODO: Implement comments functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comments section will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _downloadArticle() {
    // TODO: Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }
} 