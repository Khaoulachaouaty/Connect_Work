import 'package:flutter/material.dart';
import '../../../../../core/services/service_download.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    super.key,
    required this.url,
    required this.fileName,
    this.iconSize = 20,
  });

  final String url;
  final String fileName;
  final double iconSize;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool isDownloading = false;
  int progress = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDownloading ? null : _startDownload,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: isDownloading
            ? SizedBox(
                width: widget.iconSize,
                height: widget.iconSize,
                child: CircularProgressIndicator(
                  value: progress > 0 ? progress / 100 : null,
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.download,
                color: Colors.white,
                size: 20,
              ),
      ),
    );
  }

  Future<void> _startDownload() async {
    setState(() {
      isDownloading = true;
      progress = 0;
    });

    final filePath = await DownloadService.downloadFile(
      url: widget.url,
      fileName: widget.fileName,
      onProgress: (p) => setState(() => progress = p),
    );

    setState(() => isDownloading = false);

    if (filePath != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Téléchargé: ${widget.fileName}'),
          action: SnackBarAction(
            label: 'OUVRIR',
            onPressed: () => DownloadService.openFile(filePath),
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec du téléchargement')),
      );
    }
  }
}