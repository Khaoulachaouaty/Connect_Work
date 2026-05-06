// lib/features/admin/dashboard/presentation/views/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../admin_drawer.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/stats_grid.dart';
import 'widgets/welcome_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_activities.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<DashboardCubit>().loadStats(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardHeader(onRefresh: () => context.read<DashboardCubit>().loadStats()),
                    const SizedBox(height: 24),
                    WelcomeCard(),
                    const SizedBox(height: 24),
                    StatsGrid(stats: state.stats),
                    const SizedBox(height: 24),
                    const QuickActions(),
                    const SizedBox(height: 24),
                    const RecentActivities(),
                  ],
                ),
              ),
            );
          }
          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardCubit>().loadStats(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}