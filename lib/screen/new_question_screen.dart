import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NewQuestionScreen extends StatefulWidget {
  const NewQuestionScreen({super.key});

  @override
  State<NewQuestionScreen> createState() => _NewQuestionScreenState();
}

class _NewQuestionScreenState extends State<NewQuestionScreen> {
  String? _selectedCourse;

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
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurface, size: 20),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCcfJLtYhrdAFyVXXOAUckTsWCm8kATPP07nAKB2OopuI8ky7pl_3siFpazC6jVbZE6hGkWpwdiqNFDqGhdxPllMN6pDkGPCIdTnhcvJ7YhBGS7vS_2MmqakkHhgqoi1NXHyKu_pJepoAwq_5qpDGt6h9kT5Dc4gUObUyktSLIe8ks_r831pOn3Nj_UqDF6QxcSENdR32J7K-r8MFECvnxDj0IiViZbBwINry19EOBLhTSRjG8XhLDrtP_cE7EJV8h7rjlEfX2Yl7vm'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitleInput(),
            const SizedBox(height: 32),
            _buildCourseDropdown(),
            const SizedBox(height: 32),
            _buildDetailsArea(),
            const SizedBox(height: 32),
            _buildTagsSection(),
            const SizedBox(height: 100), // padding for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Title',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'What is your question about?',
            hintStyle: const TextStyle(color: AppColors.outline, fontSize: 14),
            filled: true,
            fillColor: AppColors.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCourseDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Select Course/Topic',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCourse,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Choose a category', style: TextStyle(color: AppColors.outline, fontSize: 14)),
              ),
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.expand_more, color: AppColors.outline),
              ),
              items: <String>['Advanced Typography', 'User Experience Design', 'Digital Curation Systems', 'History of Modern Art']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(value, style: const TextStyle(color: AppColors.onSurface, fontSize: 14)),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCourse = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Details',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'MARKDOWN SUPPORTED',
                style: TextStyle(
                  color: AppColors.outline,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
                  border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.1))),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    _buildToolbarIcon(Icons.format_bold),
                    _buildToolbarIcon(Icons.format_italic),
                    _buildToolbarIcon(Icons.link),
                    _buildToolbarIcon(Icons.format_list_bulleted),
                    Container(width: 1, height: 16, color: AppColors.outlineVariant.withValues(alpha: 0.3), margin: const EdgeInsets.symmetric(horizontal: 4)),
                    _buildToolbarIcon(Icons.image),
                  ],
                ),
              ),
              TextField(
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Provide more context for your question...',
                  hintStyle: TextStyle(color: AppColors.outline, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
                style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToolbarIcon(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: AppColors.onSurfaceVariant, size: 18),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Add Tags',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Max 5 tags',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTagChip('Design Theory'),
            _buildTagChip('Curator'),
            _buildSuggestedTag(),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Type and press enter...',
            hintStyle: const TextStyle(color: AppColors.outline, fontSize: 14),
            filled: true,
            fillColor: AppColors.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryFixed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: AppColors.onSecondaryFixed, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          const Icon(Icons.close, color: AppColors.onSecondaryFixed, size: 14),
        ],
      ),
    );
  }

  Widget _buildSuggestedTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid), // Flutter doesn't have dashed border built-in natively easily, using solid
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.add, color: AppColors.outline, size: 14),
          SizedBox(width: 4),
          Text('Suggested', style: TextStyle(color: AppColors.outline, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 32, offset: const Offset(0, -8)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Draft', style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1, // Actually 1.5 in HTML, but we can use 3/2 ratio or flex
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: AppColors.onTertiary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Post Question', style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.bold, fontSize: 14)),
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
