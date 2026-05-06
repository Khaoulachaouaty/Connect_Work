// lib/features/admin/drawer/presentation/views/widgets/drawer_header.dart
import 'package:flutter/material.dart';

class DrawerHeaderWidget extends StatefulWidget {
  final String adminName;
  final String adminEmail;

  const DrawerHeaderWidget({
    super.key, 
    required this.adminName, 
    required this.adminEmail,
  });

  @override
  State<DrawerHeaderWidget> createState() => _DrawerHeaderWidgetState();
}

class _DrawerHeaderWidgetState extends State<DrawerHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'A';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade600,
            Colors.purple.shade600,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 60),
          ScaleTransition(
            scale: _scaleAnimation,
            child: _buildAvatar(),
          ),
          const SizedBox(height: 16),
          _buildAdminName(),
          const SizedBox(height: 6),
          _buildAdminEmail(),
          const SizedBox(height: 12),
          _buildRoleBadge(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 45,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 41,
          backgroundColor: Colors.blue.shade600,
          child: Text(
            _getInitials(widget.adminName),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminName() {
    return Text(
      widget.adminName,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAdminEmail() {
    return Text(
      widget.adminEmail,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.admin_panel_settings, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Admin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}