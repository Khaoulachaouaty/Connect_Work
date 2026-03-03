import 'package:flutter/material.dart';

class GroupAppBar extends StatelessWidget {
  final String imageUrl;

  const GroupAppBar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}