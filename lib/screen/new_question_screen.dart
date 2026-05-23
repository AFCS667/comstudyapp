import 'package:comstudyapp/main.dart';
import 'package:comstudyapp/models/forum_model.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NewQuestionScreen extends StatefulWidget {
  const NewQuestionScreen({super.key});

  @override
  State<NewQuestionScreen> createState() => _NewQuestionScreenState();
}

class _NewQuestionScreenState extends State<NewQuestionScreen> {
  String? _selectedCourse;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    // 1. Validasi Input Form
    if (_titleController.text.trim().isEmpty ||
        _detailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and select a course.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2. Tampilkan Loading Indicator agar user tahu proses sedang berjalan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final user = supabase.auth.currentUser;

      final String displayName = user?.userMetadata?['username'] ?? user?.email?.split('@').first;

      final List<String> tagValue = _selectedCourse != null
          ? ['#${_selectedCourse!.replaceAll(' ', '')}']
          : ['#General'];

      final newPost = ForumPost(
        id: '',
        avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=${Uri.encodeComponent(displayName)}',
        title: _titleController.text.trim(),
        meta: 'by $displayName',
        excerpt: _detailsController.text.trim(),
        tags: tagValue,
        repliesList: [],
        replies: 0,
        likes: 0,
        isHighlight: false,
      );

      await supabase.from('posts').insert(newPost.toJson());

      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(
          context,
          true,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      debugPrint('Error creating post ke Supabase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.85),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.onSurface,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'New Question',
          style: TextStyle(
            color: AppColors.primaryContainer,
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'TITLE',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'What\'s your question?',
                      hintStyle: TextStyle(
                        color: AppColors.outline.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'CATEGORY / COURSE',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCourseDropdown(),
                  const SizedBox(height: 32),
                  const Text(
                    'DETAILS',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _detailsController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Provide background details, code snippets, or logs...',
                      hintStyle: TextStyle(
                        color: AppColors.outline.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildCourseDropdown() {
    final courses = [
      'Human Computer Interaction',
      'Mobile Application Development',
      'Research Methodology',
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCourse,
          hint: const Text(
            'Select a course',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.onSurfaceVariant,
          ),
          items: courses.map((course) {
            return DropdownMenuItem(
              value: course,
              child: Text(
                course,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedCourse = val),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHigh,
                  foregroundColor: AppColors.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Save Draft',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.tertiaryContainer, AppColors.tertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed:
                      _submitForm, // Memanggil fungsi submit yang sudah diperbaiki
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: AppColors.onTertiary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Post Question',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.send, size: 16),
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
