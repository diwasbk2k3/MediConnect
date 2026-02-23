import 'package:flutter/material.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';

class ReportViewerScreen extends StatelessWidget {
  final ReportEntity report;

  const ReportViewerScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullUrl = '${ApiEndpoints.baseUrl}/${report.reportUrl}';
    final isPdf = (report.reportUrl ?? '').toLowerCase().endsWith('.pdf');

    return Scaffold(
      appBar: AppBar(
        title: Text(report.department ?? 'Report'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: isPdf 
          ? _buildPdfViewer(context, fullUrl) 
          : _buildImageViewer(context, fullUrl),
    );
  }

  Widget _buildImageViewer(BuildContext context, String fullUrl) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  fullUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Failed to load image'),
                          const SizedBox(height: 8),
                          Text(
                            'URL: $fullUrl',
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            if (report.remarks != null && report.remarks!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Clinical Assessment',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.amber.shade200,
                        ),
                      ),
                      child: Text(
                        report.remarks!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfViewer(BuildContext context, String fullUrl) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'PDF Report',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              fullUrl,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement PDF viewer using pdf package
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PDF viewer coming soon'),
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
