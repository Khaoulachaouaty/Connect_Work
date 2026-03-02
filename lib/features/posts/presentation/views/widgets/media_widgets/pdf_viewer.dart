import 'package:flutter/material.dart';

class PdfViewer extends StatelessWidget {
  const PdfViewer({
    super.key,
    required this.pdfUrl,
    required this.fileName,
  });

  final String pdfUrl;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPdf(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            // Icône PDF
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.picture_as_pdf,
                color: Colors.red.shade700,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            // Infos fichier
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PDF • 2.4 MB',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Bouton télécharger
            IconButton(
              onPressed: () => _downloadPdf(context),
              icon: const Icon(Icons.download, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  void _openPdf(BuildContext context) {
    // TODO: Ouvrir le PDF avec un viewer
    // Utiliser: pdfx, flutter_pdfview ou url_launcher
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ouvrir PDF'),
        content: Text('Ouvrir $fileName ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Ouvrir PDF
              Navigator.pop(context);
            },
            child: const Text('Ouvrir'),
          ),
        ],
      ),
    );
  }

  void _downloadPdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Téléchargement de $fileName...')),
    );
  }
}