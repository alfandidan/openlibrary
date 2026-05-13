import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _selectedCategory;
  String? _selectedLicense;
  String? _coverFileName;
  String? _bookFileName;
  bool _isLoading = false;
  double _uploadProgress = 0;

  final List<String> _categories = [
    'Fiksi',
    'Non-Fiksi',
    'Teknologi',
    'Bisnis',
    'Sains',
    'Sejarah',
    'Biografi',
    'Lainnya',
  ];

  final List<String> _licenses = [
    'Creative Commons',
    'Public Domain',
    'Custom',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickCover() async {
    // TODO: Implement file picker for cover image
    setState(() => _coverFileName = 'cover.jpg');
  }

  Future<void> _pickBook() async {
    // TODO: Implement file picker for book file
    setState(() => _bookFileName = 'book.epub');
  }

  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate()) return;
    if (_coverFileName == null || _bookFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih cover dan file buku'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadProgress = 0;
    });

    // Simulate upload progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() => _uploadProgress = i / 100);
      }
    }

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil diupload dan menunggu review'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Buku'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cover Image
              Text(
                'Cover Buku',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _isLoading ? null : _pickCover,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: _coverFileName != null
                      ? Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.image, size: 48),
                                  const SizedBox(height: 8),
                                  Text(_coverFileName!),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    setState(() => _coverFileName = null),
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 48),
                            SizedBox(height: 8),
                            Text('Tap untuk memilih cover'),
                            SizedBox(height: 4),
                            Text(
                              'JPEG atau PNG, maks 5MB',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Book File
              Text(
                'File Buku',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _pickBook,
                icon: Icon(_bookFileName != null ? Icons.check : Icons.upload_file),
                label: Text(_bookFileName ?? 'Pilih file EPUB atau PDF'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_bookFileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _bookFileName!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              const SizedBox(height: 24),

              // Title
              CustomTextField(
                controller: _titleController,
                label: 'Judul Buku',
                hint: 'Masukkan judul buku',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  if (value.length > 200) {
                    return 'Judul maksimal 200 karakter';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Deskripsi',
                hint: 'Masukkan deskripsi buku',
                maxLines: 5,
                maxLength: 5000,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Category
              Text(
                'Kategori',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  hintText: 'Pilih kategori',
                ),
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() => _selectedCategory = value),
                validator: (value) {
                  if (value == null) return 'Pilih kategori';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // License
              Text(
                'Lisensi',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedLicense,
                decoration: const InputDecoration(
                  hintText: 'Pilih lisensi',
                ),
                items: _licenses
                    .map((lic) => DropdownMenuItem(value: lic, child: Text(lic)))
                    .toList(),
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() => _selectedLicense = value),
                validator: (value) {
                  if (value == null) return 'Pilih lisensi';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tags
              CustomTextField(
                controller: _tagsController,
                label: 'Tags (opsional)',
                hint: 'Pisahkan dengan koma, maks 10 tags',
                enabled: !_isLoading,
              ),
              const SizedBox(height: 32),

              // Upload Progress
              if (_isLoading) ...[
                LinearProgressIndicator(value: _uploadProgress),
                const SizedBox(height: 8),
                Text(
                  'Mengupload... ${(_uploadProgress * 100).toInt()}%',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],

              // Upload Button
              CustomButton(
                text: 'Upload Buku',
                onPressed: _isLoading ? null : _handleUpload,
                isLoading: _isLoading,
                icon: Icons.cloud_upload,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
