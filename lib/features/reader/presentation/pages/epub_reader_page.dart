import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EpubReaderPage extends ConsumerStatefulWidget {
  final String bookId;

  const EpubReaderPage({super.key, required this.bookId});

  @override
  ConsumerState<EpubReaderPage> createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends ConsumerState<EpubReaderPage> {
  bool _showControls = true;
  double _fontSize = 16.0;
  int _currentThemeIndex = 0; // 0: light, 1: dark, 2: sepia

  final List<Map<String, Color>> _themes = [
    {'bg': Colors.white, 'text': Colors.black87},
    {'bg': const Color(0xFF1A1A1A), 'text': Colors.white},
    {'bg': const Color(0xFFF5E6D3), 'text': const Color(0xFF5C4033)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themes[_currentThemeIndex]['bg'],
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            // Reader Content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'EPUB Reader untuk buku: ${widget.bookId}\n\n'
                  'Implementasi lengkap memerlukan package epub_view.\n\n'
                  'Tap untuk menampilkan/menyembunyikan kontrol.',
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: _themes[_currentThemeIndex]['text'],
                  ),
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
                  color: Colors.black54,
                  child: SafeArea(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'EPUB Reader',
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
                          icon: const Icon(Icons.list, color: Colors.white),
                          onPressed: () {
                            // TODO: Show table of contents
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
                  color: Colors.black54,
                  padding: const EdgeInsets.all(16),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Progress
                        Row(
                          children: [
                            const Text('1', style: TextStyle(color: Colors.white)),
                            Expanded(
                              child: Slider(
                                value: 0.3,
                                onChanged: (value) {
                                  // TODO: Navigate to page
                                },
                              ),
                            ),
                            const Text('100', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Settings Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Font Size
                            IconButton(
                              icon: const Icon(Icons.text_decrease, color: Colors.white),
                              onPressed: () {
                                if (_fontSize > 12) {
                                  setState(() => _fontSize -= 2);
                                }
                              },
                            ),
                            Text(
                              '${_fontSize.toInt()}px',
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: const Icon(Icons.text_increase, color: Colors.white),
                              onPressed: () {
                                if (_fontSize < 32) {
                                  setState(() => _fontSize += 2);
                                }
                              },
                            ),
                            const SizedBox(width: 24),
                            // Theme Toggle
                            ...List.generate(3, (index) {
                              return GestureDetector(
                                onTap: () => setState(() => _currentThemeIndex = index),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: _themes[index]['bg'],
                                    border: Border.all(
                                      color: _currentThemeIndex == index
                                          ? Colors.blue
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              );
                            }),
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
