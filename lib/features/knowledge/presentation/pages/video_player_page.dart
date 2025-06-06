import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// * VIDEO PLAYER PAGE
/// * Plays educational agricultural videos
/// * Supports offline viewing and progress tracking
class VideoPlayerPage extends StatefulWidget {
  final String videoId;

  const VideoPlayerPage({
    super.key,
    required this.videoId,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isPlaying = false;
  bool _isLiked = false;
  bool _isBookmarked = false;
  double _currentPosition = 0.0;
  final double _totalDuration = 100.0; // Mock duration in seconds
  int _likes = 156;

  // * Sample video data - will be replaced with actual API data
  final Map<String, dynamic> _video = {
    'title': 'Modern Irrigation Techniques for Small Farmers',
    'description': '''
Learn about efficient irrigation methods that can help small farmers maximize water usage and improve crop yields. This video covers:

• Drip irrigation setup and benefits
• Sprinkler irrigation systems
• Water conservation techniques
• Cost-effective irrigation solutions
• Maintenance tips for irrigation equipment

Perfect for farmers looking to optimize their water usage and reduce irrigation costs while improving productivity.
    ''',
    'instructor': 'Dr. Ramesh Patel',
    'credentials': 'Agricultural Engineer',
    'duration': '8:45',
    'views': '12.3K views',
    'uploadDate': '2 weeks ago',
    'tags': ['Irrigation', 'Water Management', 'Technology', 'Farming'],
    'relatedVideos': [
      'Water-Efficient Crop Selection',
      'Solar-Powered Irrigation Systems',
      'Rainwater Harvesting for Farmers',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'Video',
        backgroundColor: Colors.black,
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
            onPressed: () => _shareVideo(),
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // * Video Player
          _buildVideoPlayer(),
          
          // * Video Info and Actions
          Expanded(
            child: Container(
              color: CropFreshColors.background60Secondary,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVideoInfo(),
                    _buildVideoActions(),
                    _buildVideoDescription(),
                    _buildRelatedVideos(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // * Video thumbnail/placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[900],
              child: Icon(
                Icons.play_circle_fill,
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            
            // * Play/Pause overlay
            Center(
              child: GestureDetector(
                onTap: () => _togglePlayPause(),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            
            // * Progress bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: CropFreshColors.knowledge,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbColor: CropFreshColors.knowledge,
                        overlayShape: SliderComponentShape.noOverlay,
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: _currentPosition,
                        max: _totalDuration,
                        onChanged: (value) {
                          setState(() {
                            _currentPosition = value;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_currentPosition),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatDuration(_totalDuration),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Video Title
          Text(
            _video['title'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // * Video Stats
          Row(
            children: [
              Text(
                '${_video['views']} • ${_video['uploadDate']}',
                style: TextStyle(
                  fontSize: 14,
                  color: CropFreshColors.neutral50,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // * Instructor Information
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: CropFreshColors.knowledge,
                child: Text(
                  _video['instructor'].substring(0, 2).toUpperCase(),
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
                      _video['instructor'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _video['credentials'],
                      style: TextStyle(
                        fontSize: 12,
                        color: CropFreshColors.neutral50,
                      ),
                    ),
                  ],
                ),
              ),
              
              // * Subscribe/Follow button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement follow functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CropFreshColors.knowledge,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Follow'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // * Tags
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _video['tags'].map<Widget>((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: CropFreshColors.neutral90,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    color: CropFreshColors.neutral50,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoActions() {
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
                    ? CropFreshColors.knowledge.withOpacity(0.1)
                    : CropFreshColors.neutral95,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 16,
                    color: _isLiked 
                        ? CropFreshColors.knowledge
                        : CropFreshColors.neutral50,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$_likes',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isLiked 
                          ? CropFreshColors.knowledge
                          : CropFreshColors.neutral50,
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
                color: CropFreshColors.neutral95,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: CropFreshColors.neutral50,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Comment',
                    style: TextStyle(
                      fontSize: 14,
                      color: CropFreshColors.neutral50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // * Download Button
          InkWell(
            onTap: () => _downloadVideo(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: CropFreshColors.knowledge,
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

  Widget _buildVideoDescription() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _video['description'],
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedVideos() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Videos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          ..._video['relatedVideos'].map<Widget>((video) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  // TODO: Navigate to related video
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          color: CropFreshColors.knowledge.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.play_circle_fill,
                          color: CropFreshColors.knowledge,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          video,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    // TODO: Implement actual video play/pause
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked 
              ? 'Video bookmarked' 
              : 'Bookmark removed',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareVideo() {
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

  void _downloadVideo() {
    // TODO: Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final int minutes = (seconds / 60).floor();
    final int remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
} 