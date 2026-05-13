import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PdfReaderPage extends ConsumerStatefulWidget {
  final String bookId;

  const PdfReaderPage({super.key, required this.bookId});

  @override
  ConsumerState<PdfReaderPage> createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends ConsumerState<PdfReaderPage> {
  bool _showControls = true;
  int _currentPage = 1;
  final int _totalPages = 100; // Placeholder
  final TextEditingController _pageController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            // PDF Content
            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  'PDF Reader untuk buku: ${widget.bookId}\n\n'
                  'Implementasi lengkap memerlukan package syncfusion_flutter_pdfviewer.\n\n'
                  'Halaman $_currentPage dari $_totalPages\n\n'
                  'Tap untuk menampilkan/menyembunyikan kontrol.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Top Controls
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black87,
                  child: SafeArea(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'PDF Reader',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border, color: Colors.white),
                          onPressed: () {
                            // TODO: Add bookmark
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            // TODO: Share
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom Controls
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.all(16),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page indicator
                        Text(
                          'Halaman $_currentPage dari $_totalPages',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        // Page slider
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.first_page, color: Colors.white),
                              onPressed: () => setState(() => _currentPage = 1),
                            ),
                            Expanded(
                              child: Slider(
                                value: _currentPage.toDouble(),
                                min: 1,
                                max: _totalPages.toDouble(),
                                onChanged: (value) {
                                  setState(() => _currentPage = value.toInt());
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.last_page, color: Colors.white),
                              onPressed: () => setState(() => _currentPage = _totalPages),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Go to page
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ke halaman: ',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _pageController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white54),
                                  ),
                                ),
                                onSubmitted: (value) {
                                  final page = int.tryParse(value);
                                  if (page != null && page >= 1 && page <= _totalPages) {
                                    setState(() => _currentPage = page);
                                  }
                                  _pageController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
