// ===================================================================
// * KNOWLEDGE HUB PAGE (KRISHIGYAN KENDRA)
// * Purpose: Main knowledge center for agricultural education and guidance
// * Features: Content categories, featured articles, videos, expert Q&A
// * Security Level: LOW - Educational content access
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/fade_in_animation.dart';
import '../bloc/knowledge_bloc.dart';

class KnowledgeHubPage extends StatefulWidget {
  const KnowledgeHubPage({super.key});

  @override
  State<KnowledgeHubPage> createState() => _KnowledgeHubPageState();
}

class _KnowledgeHubPageState extends State<KnowledgeHubPage> 
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _selectedLanguage = 'Kannada';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // * Load knowledge hub data when page initializes
    context.read<KnowledgeBloc>().add(const LoadKnowledgeContent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'KrishiGyan Kendra',
        actions: [
          IconButton(
            onPressed: () => _showLanguageSelector(),
            icon: const Icon(Icons.language),
            tooltip: 'Change Language',
          ),
          IconButton(
            onPressed: () => context.push('/main/knowledge/search'),
            icon: const Icon(Icons.search),
            tooltip: 'Search Content',
          ),
        ],
      ),
      body: BlocBuilder<KnowledgeBloc, KnowledgeState>(
        builder: (context, state) {
          if (state is KnowledgeLoading) {
            return const LoadingWidget();
          }
          
          if (state is KnowledgeError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<KnowledgeBloc>().add(const LoadKnowledgeContent());
              },
            );
          }
          
          if (state is KnowledgeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<KnowledgeBloc>().add(const RefreshKnowledgeContent());
              },
              child: _buildKnowledgeContent(state),
            );
          }
          
          return const LoadingWidget();
        },
      ),
    );
  }

  Widget _buildKnowledgeContent(KnowledgeLoaded state) {
    return Column(
      children: [
        // * Search Bar
        _buildSearchSection(),
        
        // * Tab Navigation
        _buildTabBar(),
        
        // * Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFeaturedContent(state),
              _buildArticlesTab(state),
              _buildVideosTab(state),
              _buildExpertQATab(state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search knowledge base...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        onChanged: (value) {
          setState(() {});
          // TODO: Implement search functionality
        },
        onSubmitted: (value) {
          // TODO: Perform search
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: CropFreshColors.green30Primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        tabs: const [
          Tab(text: 'Featured'),
          Tab(text: 'Articles'),
          Tab(text: 'Videos'),
          Tab(text: 'Expert Q&A'),
        ],
      ),
    );
  }

  Widget _buildFeaturedContent(KnowledgeLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Featured Article of the Day
          _buildSectionHeader('Today\'s Featured'),
          FadeInAnimation(
            child: _buildFeaturedCard(state.featuredContent),
          ),
          
          const SizedBox(height: 24),
          
          // * Quick Categories
          _buildSectionHeader('Quick Categories'),
          _buildCategoryGrid(),
          
          const SizedBox(height: 24),
          
          // * Trending Topics
          _buildSectionHeader('Trending This Week'),
          _buildTrendingList(state.trendingContent),
          
          const SizedBox(height: 24),
          
          // * Recent Updates
          _buildSectionHeader('Recent Updates'),
          _buildRecentUpdatesList(state.recentContent),
        ],
      ),
    );
  }

  Widget _buildArticlesTab(KnowledgeLoaded state) {
    return Column(
      children: [
        // * Category Filter
        _buildCategoryFilter(),
        
        // * Articles List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.articles.length,
            itemBuilder: (context, index) {
              final article = state.articles[index];
              return FadeInAnimation(
                delay: Duration(milliseconds: index * 100),
                child: _buildArticleCard(article),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideosTab(KnowledgeLoaded state) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16 / 12,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.videos.length,
      itemBuilder: (context, index) {
        final video = state.videos[index];
        return FadeInAnimation(
          delay: Duration(milliseconds: index * 100),
          child: _buildVideoCard(video),
        );
      },
    );
  }

  Widget _buildExpertQATab(KnowledgeLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.expertQA.length,
      itemBuilder: (context, index) {
        final qa = state.expertQA[index];
        return FadeInAnimation(
          delay: Duration(milliseconds: index * 100),
          child: _buildQACard(qa),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> content) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToContent(content),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Featured Image
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: content['image'] != null
                  ? Image.network(
                      content['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 60);
                      },
                    )
                  : const Icon(Icons.agriculture, size: 60),
            ),
            
            // * Content Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CropFreshColors.green30Container,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      content['category'] ?? 'General',
                      style: TextStyle(
                        fontSize: 12,
                        color: CropFreshColors.green30Primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    content['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    content['description'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${content['readTime'] ?? 5} min read',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${content['views'] ?? 0}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'name': 'Crop Cultivation', 'icon': Icons.agriculture, 'color': Colors.green},
      {'name': 'Pest Management', 'icon': Icons.bug_report, 'color': Colors.red},
      {'name': 'Soil Health', 'icon': Icons.landscape, 'color': Colors.brown},
      {'name': 'Weather Guide', 'icon': Icons.cloud, 'color': Colors.blue},
      {'name': 'Market Insights', 'icon': Icons.trending_up, 'color': Colors.orange},
      {'name': 'Government Schemes', 'icon': Icons.account_balance, 'color': Colors.purple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final color = category['color'] as Color;
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category-specific content
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category['icon'] as IconData,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                category['name'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingList(List<Map<String, dynamic>> trending) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trending.length,
      itemBuilder: (context, index) {
        final item = trending[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CropFreshColors.green30Container,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: CropFreshColors.green30Primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            item['title'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${item['views'] ?? 0} views',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          onTap: () => _navigateToContent(item),
        );
      },
    );
  }

  Widget _buildRecentUpdatesList(List<Map<String, dynamic>> recent) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.length,
      itemBuilder: (context, index) {
        final item = recent[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: CropFreshColors.green30Container,
              child: Icon(
                Icons.article,
                color: CropFreshColors.green30Primary,
              ),
            ),
            title: Text(
              item['title'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              item['updatedAt'] ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _navigateToContent(item),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['All', 'Crop Care', 'Pest Control', 'Soil Health', 'Weather', 'Market'];
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
                // TODO: Filter articles by category
              },
              backgroundColor: Colors.grey.shade100,
              selectedColor: CropFreshColors.green30Container,
              labelStyle: TextStyle(
                color: isSelected ? CropFreshColors.green30Primary : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToContent(article),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * Article Thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: article['thumbnail'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          article['thumbnail'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.article);
                          },
                        ),
                      )
                    : const Icon(Icons.article),
              ),
              
              const SizedBox(width: 12),
              
              // * Article Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      article['summary'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: CropFreshColors.green30Container,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            article['category'] ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              color: CropFreshColors.green30Primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        Text(
                          '${article['readTime'] ?? 5} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToVideo(video),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Video Thumbnail
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Stack(
                  children: [
                    if (video['thumbnail'] != null)
                      Image.network(
                        video['thumbnail'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.video_library, size: 40);
                        },
                      )
                    else
                      const Center(
                        child: Icon(Icons.video_library, size: 40),
                      ),
                    
                    // * Play Button Overlay
                    const Center(
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    
                    // * Duration Badge
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video['duration'] ?? '0:00',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // * Video Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    '${video['views'] ?? 0} views',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQACard(Map<String, dynamic> qa) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToQA(qa),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * Question
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.help_outline,
                    color: CropFreshColors.green30Primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      qa['question'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // * Answer Preview
              Text(
                qa['answerPreview'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // * Expert Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: CropFreshColors.green30Container,
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: CropFreshColors.green30Primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          qa['expertName'] ?? 'Agricultural Expert',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          qa['expertTitle'] ?? '',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    qa['answeredAt'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final languages = ['Kannada', 'Telugu', 'Hindi', 'English'];
        
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...languages.map((language) => ListTile(
                title: Text(language),
                leading: Radio<String>(
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                    // TODO: Update content language
                  },
                ),
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  void _navigateToContent(Map<String, dynamic> content) {
    if (content['type'] == 'article') {
      context.push('/main/knowledge/article/${content['id']}');
    } else if (content['type'] == 'video') {
      context.push('/main/knowledge/video/${content['id']}');
    }
  }

  void _navigateToVideo(Map<String, dynamic> video) {
    context.push('/main/knowledge/video/${video['id']}');
  }

  void _navigateToQA(Map<String, dynamic> qa) {
    context.push('/main/knowledge/qa/${qa['id']}');
  }
} 