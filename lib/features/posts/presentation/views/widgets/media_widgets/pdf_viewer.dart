// lib/features/posts/presentation/views/widgets/media_widgets/pdf_viewer.dart
import 'package:flutter/material.dart';

class PdfViewer extends StatelessWidget {
  final String pdfUrl;
  final String fileName;

  const PdfViewer({
    super.key,
    required this.pdfUrl,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Ouvrir le PDF
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.picture_as_pdf, color: Colors.red.shade700),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('PDF • Document', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.download, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}