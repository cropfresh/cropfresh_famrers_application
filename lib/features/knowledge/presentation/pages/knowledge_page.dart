import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import 'article_detail_page.dart';
import 'video_player_page.dart';

/// * KNOWLEDGE HUB (KRISHIGYAN KENDRA)
/// * Educational content and expert guidance for farmers
/// * Features: Articles, videos, expert Q&A, seasonal guidance
class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: CustomAppBar(
        title: 'KrishiGyan Kendra',
        backgroundColor: CropFreshColors.green30Primary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showSearchDialog(),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildArticlesTab(),
                _buildVideosTab(),
                _buildExpertQATab(),
                _buildSeasonalGuidanceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: CropFreshColors.background60Card,
      child: TabBar(
        controller: _tabController,
        labelColor: CropFreshColors.green30Primary,
        unselectedLabelColor: CropFreshColors.onBackground60Secondary,
        indicatorColor: CropFreshColors.green30Primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Articles'),
          Tab(text: 'Videos'),
          Tab(text: 'Expert Q&A'),
          Tab(text: 'Seasonal'),
        ],
      ),
    );
  }

  Widget _buildArticlesTab() {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 10,
            itemBuilder: (context, index) => _buildArticleCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['All', 'Crop Cultivation', 'Pest Control', 'Organic Farming', 'Market Tips'];
    
    return Container(
      height: 60,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: CropFreshColors.background60Card,
              selectedColor: CropFreshColors.green30Container,
              checkmarkColor: CropFreshColors.green30Primary,
              labelStyle: TextStyle(
                color: isSelected 
                    ? CropFreshColors.green30Primary 
                    : CropFreshColors.onBackground60Secondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleCard(int index) {
    final articles = [
      {
        'title': 'Organic Pest Control Methods',
        'description': 'Learn natural ways to protect your crops from pests using eco-friendly methods',
        'category': 'Pest Control',
        'readTime': '5 min read',
        'author': 'Dr. Rajesh Kumar',
        'date': '2 days ago',
        'isBookmarked': false,
      },
      {
        'title': 'Maximizing Tomato Yield',
        'description': 'Expert tips on growing healthy tomato plants with high productivity',
        'category': 'Crop Cultivation',
        'readTime': '8 min read',
        'author': 'Prof. Sunita Sharma',
        'date': '1 week ago',
        'isBookmarked': true,
      },
      // Add more mock articles
    ];

    final article = articles[index % articles.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToArticle(article),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CropFreshColors.green30Container,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        article['category']!,
                        style: TextStyle(
                          color: CropFreshColors.green30Primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _toggleBookmark(index),
                      icon: Icon(
                        article['isBookmarked'] == true
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: CropFreshColors.green30Primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article['title']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article['description']!,
                  style: TextStyle(
                    color: CropFreshColors.onBackground60Secondary,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 14,
                      color: CropFreshColors.onBackground60Tertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article['author']!,
                      style: TextStyle(
                        color: CropFreshColors.onBackground60Tertiary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: CropFreshColors.onBackground60Tertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article['readTime']!,
                      style: TextStyle(
                        color: CropFreshColors.onBackground60Tertiary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      article['date']!,
                      style: TextStyle(
                        color: CropFreshColors.onBackground60Tertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => _buildVideoCard(index),
    );
  }

  Widget _buildVideoCard(int index) {
    final videos = [
      {
        'title': 'Drip Irrigation Setup',
        'duration': '12:45',
        'views': '15.2K views',
        'category': 'Irrigation',
      },
      {
        'title': 'Composting Techniques',
        'duration': '8:30',
        'views': '8.7K views',
        'category': 'Organic Farming',
      },
      // Add more mock videos
    ];

    final video = videos[index % videos.length];

    return Container(
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _playVideo(video),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CropFreshColors.green30Container,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          size: 48,
                          color: CropFreshColors.green30Primary,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            video['duration']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video['category']!,
                        style: TextStyle(
                          color: CropFreshColors.green30Primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        video['views']!,
                        style: TextStyle(
                          color: CropFreshColors.onBackground60Secondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpertQATab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) => _buildQACard(index),
    );
  }

  Widget _buildQACard(int index) {
    final questions = [
      {
        'question': 'Why are my tomato leaves turning yellow?',
        'category': 'Plant Disease',
        'askedBy': 'Ravi Farmer',
        'timeAgo': '2 hours ago',
        'answers': 3,
        'isAnswered': true,
      },
      {
        'question': 'Best time to plant wheat in Karnataka?',
        'category': 'Crop Planning',
        'askedBy': 'Sunita Devi',
        'timeAgo': '5 hours ago',
        'answers': 1,
        'isAnswered': true,
      },
      // Add more mock Q&As
    ];

    final qa = questions[index % questions.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: qa['isAnswered'] == true
              ? CropFreshColors.green30Container
              : CropFreshColors.orange10Container,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CropFreshColors.green30Container,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  qa['category']!,
                  style: TextStyle(
                    color: CropFreshColors.green30Primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: qa['isAnswered'] == true
                      ? CropFreshColors.green30Container
                      : CropFreshColors.orange10Container,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  qa['isAnswered'] == true ? 'Answered' : 'Pending',
                  style: TextStyle(
                    color: qa['isAnswered'] == true
                        ? CropFreshColors.green30Primary
                        : CropFreshColors.orange10Primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            qa['question']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 14,
                color: CropFreshColors.onBackground60Tertiary,
              ),
              const SizedBox(width: 4),
              Text(
                qa['askedBy']!,
                style: TextStyle(
                  color: CropFreshColors.onBackground60Tertiary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                size: 14,
                color: CropFreshColors.onBackground60Tertiary,
              ),
              const SizedBox(width: 4),
              Text(
                qa['timeAgo']!,
                style: TextStyle(
                  color: CropFreshColors.onBackground60Tertiary,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.question_answer,
                size: 14,
                color: CropFreshColors.green30Primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${qa['answers']} answers',
                style: TextStyle(
                  color: CropFreshColors.green30Primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalGuidanceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSeasonalCard(
          title: 'December Farming Activities',
          season: 'Rabi Season',
          activities: [
            'Wheat sowing in North India',
            'Mustard cultivation starts',
            'Winter vegetable planting',
            'Pest control for standing crops',
          ],
        ),
        _buildSeasonalCard(
          title: 'Upcoming Tasks - January',
          season: 'Winter Season',
          activities: [
            'Irrigation management for Rabi crops',
            'Fertilizer application for wheat',
            'Harvesting late Kharif crops',
            'Preparation for spring vegetables',
          ],
        ),
      ],
    );
  }

  Widget _buildSeasonalCard({
    required String title,
    required String season,
    required List<String> activities,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CropFreshColors.orange10Container,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  season,
                  style: TextStyle(
                    color: CropFreshColors.orange10Primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: BoxDecoration(
                    color: CropFreshColors.green30Primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    activity,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Knowledge Base'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for articles, videos, or topics...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: CropFreshColors.green30Primary,
            ),
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toggleBookmark(int index) {
    setState(() {
      // TODO: Implement bookmark toggle logic
    });
  }

  void _navigateToArticle(Map<String, dynamic> article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(article: article),
      ),
    );
  }

  void _playVideo(Map<String, dynamic> video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(video: video),
      ),
    );
  }
} 