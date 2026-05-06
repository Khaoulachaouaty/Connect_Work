// lib/features/admin/groups/presentation/views/widgets/group_banner.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'group_privacy_badge.dart';

class GroupBanner extends StatelessWidget {
  final String? imageUrl;
  final bool isPrivate;
  final double height;

  const GroupBanner({
    super.key,
    required this.imageUrl,
    required this.isPrivate,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Stack(
        children: [
          hasImage
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  height: height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: height,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => _buildGradientBanner(),
                )
              : _buildGradientBanner(),
          Positioned(
            top: 12,
            right: 12,
            child: GroupPrivacyBadge(isPrivate: isPrivate),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBanner() {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isPrivate ? Colors.orange.shade400 : Colors.blue.shade400,
            isPrivate ? Colors.orange.shade700 : Colors.blue.shade700,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          isPrivate ? Icons.lock_outline : Icons.group_outlined,
          size: 40,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
}