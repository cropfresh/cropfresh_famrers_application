// ===================================================================
// * DASHBOARD PAGE
// * Purpose: Main dashboard page for farmers app
// * Features: Weather, market prices, farm stats, quick actions
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/dashboard_content.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when page initializes
    context.read<DashboardBloc>().add(LoadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const LoadingWidget(
              message: 'Loading your dashboard...',
              showMessage: true,
            );
          }
          
          if (state is DashboardError) {
            return CustomErrorWidget(
              title: 'Failed to load dashboard',
              message: state.message,
              onRetry: () {
                context.read<DashboardBloc>().add(LoadDashboardData());
              },
            );
          }
          
          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(RefreshDashboard());
              },
              child: const DashboardContent(),
            );
          }
          
          return const LoadingWidget();
        },
      ),
    );
  }
} 