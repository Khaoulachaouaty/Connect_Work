import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        // Bouton télécharger
        Positioned(
          top: 8,
          right: 8,
          child: _DownloadButton(
            url: imageUrl,
            fileName: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        ),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({required this.url, required this.fileName});

  final String url;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _downloadFile(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.download,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _downloadFile(BuildContext context) {
    // TODO: Implémenter le téléchargement
    // Utiliser: dio, http ou flutter_downloader
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Téléchargement de $fileName...')),
    );
  }
}