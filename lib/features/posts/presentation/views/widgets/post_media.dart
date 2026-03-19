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
        PostMediaType.image => post.mediaUrl != null
            ? ImageViewer(imageUrl: post.mediaUrl!)
            : const Center(child: Text('Image non disponible')),
        PostMediaType.video => post.mediaUrl != null
            ? VideoPlayer(videoUrl: post.mediaUrl!)
            : const Center(child: Text('Vidéo non disponible')),
        PostMediaType.pdf => post.mediaUrl != null
            ? PdfViewer(
                pdfUrl: post.mediaUrl!,
                fileName: post.fileName ?? 'document.pdf',
              )
            : const Center(child: Text('Document non disponible')),
        PostMediaType.none => const SizedBox.shrink(),
      },
    );
  }
}