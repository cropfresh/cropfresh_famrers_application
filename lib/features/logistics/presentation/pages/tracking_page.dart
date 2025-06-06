// ===================================================================
// * TRACKING PAGE
// * Purpose: Real-time tracking of logistics bookings and shipments
// * Features: Live GPS tracking, status updates, driver contact, delivery proof
// * Security Level: Medium - Contains location and delivery information
// ===================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';

class TrackingPage extends StatefulWidget {
  final String bookingId;
  
  const TrackingPage({super.key, required this.bookingId});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isLoading = true;
  
  // ! Mock tracking data - replace with real API
  Map<String, dynamic>? _trackingData;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _loadTrackingData();
  }

  Future<void> _loadTrackingData() async {
    setState(() => _isLoading = true);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _trackingData = {
          'bookingId': widget.bookingId,
          'status': 'in_transit',
          'pickupLocation': 'Farmer\'s Field, Mysore Road, Bangalore',
          'deliveryLocation': 'City Market, KR Market, Bangalore',
          'driverName': 'Rajesh Kumar',
          'driverPhone': '+91 9876543210',
          'vehicleNumber': 'KA 01 AB 1234',
          'vehicleType': 'Pickup Truck',
          'estimatedDelivery': '2:30 PM',
          'currentLocation': 'Electronic City, Bangalore',
          'distance': 25.5,
          'progress': 0.65,
          'timeline': [
            {
              'title': 'Booking Confirmed',
              'time': '9:00 AM',
              'description': 'Your booking has been confirmed',
              'completed': true,
            },
            {
              'title': 'Driver Assigned',
              'time': '9:15 AM',
              'description': 'Rajesh Kumar will be your driver',
              'completed': true,
            },
            {
              'title': 'Pickup Started',
              'time': '10:30 AM',
              'description': 'Driver is on the way to pickup location',
              'completed': true,
            },
            {
              'title': 'Goods Loaded',
              'time': '11:45 AM',
              'description': 'Items successfully loaded and secured',
              'completed': true,
            },
            {
              'title': 'In Transit',
              'time': '12:00 PM',
              'description': 'On the way to delivery location',
              'completed': true,
              'current': true,
            },
            {
              'title': 'Arriving Soon',
              'time': '2:15 PM',
              'description': 'Driver will arrive in 15 minutes',
              'completed': false,
            },
            {
              'title': 'Delivered',
              'time': '2:30 PM',
              'description': 'Items delivered successfully',
              'completed': false,
            },
          ],
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Track Shipment',
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTrackingData,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _trackingData != null
              ? _buildTrackingContent()
              : _buildErrorState(),
    );
  }

  Widget _buildTrackingContent() {
    return RefreshIndicator(
      onRefresh: _loadTrackingData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // * Status Header
            _buildStatusHeader(),
            
            // * Progress Map/Visual
            _buildProgressSection(),
            
            // * Driver Information
            _buildDriverInfo(),
            
            // * Timeline
            _buildTimeline(),
            
            // * Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    final status = _trackingData!['status'];
    Color statusColor = AppColors.primary;
    String statusText = '';
    IconData statusIcon = Icons.local_shipping;

    switch (status) {
      case 'confirmed':
        statusColor = Colors.blue;
        statusText = 'Booking Confirmed';
        statusIcon = Icons.check_circle;
        break;
      case 'pickup':
        statusColor = Colors.orange;
        statusText = 'Pickup in Progress';
        statusIcon = Icons.location_on;
        break;
      case 'in_transit':
        statusColor = AppColors.primary;
        statusText = 'In Transit';
        statusIcon = Icons.local_shipping;
        break;
      case 'delivered':
        statusColor = Colors.green;
        statusText = 'Delivered';
        statusIcon = Icons.check_circle;
        break;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.1), statusColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    size: 32,
                    color: statusColor,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Booking ID: ${_trackingData!['bookingId']}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final progress = _trackingData!['progress'] as double;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Route Information
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.radio_button_checked, color: Colors.green, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _trackingData!['pickupLocation'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // * Progress Line
          Container(
            margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Stack(
                    children: [
                      Container(
                        width: 2,
                        height: 30,
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.only(left: 7),
                      ),
                      Positioned(
                        left: 3,
                        top: 0,
                        child: Container(
                          width: 10,
                          height: 30 * progress,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Colors.red, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'To',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _trackingData!['deliveryLocation'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // * Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}% Complete',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // * Current Location & ETA
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Location',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _trackingData!['currentLocation'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ETA: ${_trackingData!['estimatedDelivery']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  _trackingData!['driverName'][0],
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _trackingData!['driverName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange.shade400, size: 16),
                        const SizedBox(width: 4),
                        const Text('4.8'),
                        const SizedBox(width: 12),
                        Icon(Icons.local_shipping, color: Colors.grey.shade600, size: 16),
                        const SizedBox(width: 4),
                        Text(_trackingData!['vehicleType']),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Contact Buttons
              Row(
                children: [
                  IconButton(
                    onPressed: _callDriver,
                    icon: const Icon(Icons.phone),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      foregroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _messageDriver,
                    icon: const Icon(Icons.message),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Vehicle Information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.directions_car, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Vehicle: ${_trackingData!['vehicleNumber']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final timeline = _trackingData!['timeline'] as List;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tracking Timeline',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ...timeline.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == timeline.length - 1;
            final isCompleted = item['completed'] as bool;
            final isCurrent = item['current'] ?? false;
            
            return _buildTimelineItem(
              item['title'],
              item['time'],
              item['description'],
              isCompleted,
              isCurrent,
              !isLast,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String time,
    String description,
    bool isCompleted,
    bool isCurrent,
    bool hasNext,
  ) {
    Color iconColor = isCompleted ? Colors.green : (isCurrent ? AppColors.primary : Colors.grey);
    Color lineColor = isCompleted ? Colors.green : Colors.grey.shade300;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: iconColor,
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: Icon(
                isCompleted ? Icons.check : (isCurrent ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                color: iconColor,
                size: 16,
              ),
            ),
            if (hasNext)
              Container(
                width: 2,
                height: 40,
                color: lineColor,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        
        const SizedBox(width: 12),
        
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: hasNext ? 20 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                        color: isCurrent ? AppColors.primary : null,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _shareLiveLocation,
              icon: const Icon(Icons.share_location),
              label: const Text('Share Live Location'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _reportIssue,
                  icon: const Icon(Icons.report_problem),
                  label: const Text('Report Issue'),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _viewInvoice,
                  icon: const Icon(Icons.receipt),
                  label: const Text('View Invoice'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Unable to load tracking information',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadTrackingData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _callDriver() {
    // TODO: Implement phone call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling driver...')),
    );
  }

  void _messageDriver() {
    // TODO: Implement messaging functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat with driver...')),
    );
  }

  void _shareLiveLocation() {
    // TODO: Implement location sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing live location...')),
    );
  }

  void _reportIssue() {
    // TODO: Implement issue reporting
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening issue report...')),
    );
  }

  void _viewInvoice() {
    // TODO: Implement invoice viewing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening invoice...')),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
} 