import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'package:connect_work/features/groups/data/services/group_service.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/post_card.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    final postService = getIt<PostService>();
    final groupService = GroupService();
    final authState = context.watch<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.uid : null;

    if (userId == null) {
      return StreamBuilder<List<Post>>(
        stream: postService.watchPosts(),
        builder: (context, snapshot) => _buildPostList(context, snapshot),
      );
    }

    return StreamBuilder<List<String>>(
      stream: groupService.watchUserGroupIds(userId),
      builder: (context, groupsSnapshot) {
        final joinedGroupIds = groupsSnapshot.data ?? [];
        return StreamBuilder<List<Post>>(
          stream: postService.watchPosts(joinedGroupIds: joinedGroupIds),
          builder: (context, postsSnapshot) => _buildPostList(context, postsSnapshot),
        );
      },
    );
  }

  Widget _buildPostList(BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(40.0),
        child: CircularProgressIndicator(),
      ));
    }

    if (snapshot.hasError) {
      return Center(child: Text('Erreur chargement posts : ${snapshot.error}'));
    }

    final posts = snapshot.data ?? [];
    if (posts.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Text('Aucune publication pour le moment'),
      ));
    }

    return Column(
      children: posts.map((post) => PostCard(post: post)).toList(),
    );
  }
}