import 'package:flutter/material.dart';
import '../../../data/models/post_media.dart';
import 'media_widgets/image_viewer.dart';
import 'media_widgets/video_player.dart';
import 'media_widgets/pdf_viewer.dart';

class PostMedia extends StatelessWidget {
  const PostMedia({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: switch (post.mediaType) {
        PostMediaType.image => ImageViewer(imageUrl: post.mediaUrl!),
        PostMediaType.video => VideoPlayer(videoUrl: post.mediaUrl!),
        PostMediaType.pdf => PdfViewer(
            pdfUrl: post.mediaUrl!,
            fileName: post.fileName ?? 'document.pdf',
          ),
        PostMediaType.none => const SizedBox.shrink(),
      },
    );
  }
}