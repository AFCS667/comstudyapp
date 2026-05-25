# ComStudyApp Full-Stack Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Connect meetup (with OSM map), course detail (with YouTube video), and quiz screens to Supabase BE. Everything else stays dummy.

**Architecture:** Supabase PostgreSQL with RLS. Flutter FE queries via `supabase_flutter`. OSM map via `flutter_map`. YouTube video via `youtube_player_flutter`.

**Tech Stack:** Supabase, Flutter, `flutter_map` + `latlong2`, `youtube_player_flutter`, `supabase_flutter`

---

## Scope

### Real (BE + FE connected)
- Meetups + OSM map
- Courses + modules + lessons + YouTube video player
- Quizzes (full flow: questions, options, submit answers, score)

### Dummy (keep as-is)
- Dashboard categories (hardcoded 4 items)
- Dashboard progress & upcoming meetup card (hardcoded)
- Courses screen "Your Courses" & "Browse All" (hardcoded lists)
- Lesson progress states (completed/active/locked hardcoded)

---

## Dependency Graph

```
Phase 1 — BE Tables (Supabase SQL Editor):
  profiles → meetups → meetup_participants
  courses → modules → lessons
  quizzes → quiz_questions → quiz_options → quiz_attempts → quiz_answers

Phase 2 — FE Packages (pubspec.yaml):
  flutter_map, latlong2, youtube_player_flutter

Phase 3 — FE Models:
  meetup_model, course_model, quiz_model

Phase 4 — FE Screens:
  meetup_screen → course_detail → quiz_evaluation_screen
```

---

## PHASE 1: Backend (Supabase SQL)

### Task 1: profiles table

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table + trigger**

```sql
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Profiles are viewable by authenticated users"
  ON public.profiles FOR SELECT TO authenticated USING (true);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE TO authenticated
  USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', ''),
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

- [ ] **Step 2: Verify**

```sql
SELECT * FROM public.profiles LIMIT 1;
```

Expected: empty table, no errors.

---

### Task 2: meetups table

**FE screen:** `meetup_screen.dart` (OSM map markers + meetup cards)

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table + seed data**

```sql
CREATE TABLE public.meetups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  location_name TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  event_date TIMESTAMPTZ NOT NULL,
  max_participants INT DEFAULT 30,
  tag TEXT DEFAULT 'Upcoming',
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

ALTER TABLE public.meetups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Meetups are viewable by authenticated users"
  ON public.meetups FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can create meetups"
  ON public.meetups FOR INSERT TO authenticated WITH CHECK (true);

-- Seed: lokasi di sekitar Jakarta Barat
INSERT INTO public.meetups (title, description, location_name, latitude, longitude, event_date, max_participants, tag) VALUES
  ('Flutter Study Group', 'Belajar Flutter bareng, bawa laptop masing-masing', 'Perpustakaan Universitas Trisakti', -6.1688, 106.7937, now() + interval '2 days', 20, 'Live'),
  ('Tech Talk: AI in Education', 'Diskusi tentang penerapan AI di dunia pendidikan', 'Gedung Syahdan BINUS Anggrek', -6.2019, 106.7815, now() + interval '5 days', 40, 'Offline'),
  ('Design Workshop: UI/UX', 'Workshop hands-on desain UI/UX untuk mobile app', 'WeWork Slipi, Jakarta Barat', -6.1862, 106.7996, now() + interval '10 days', 15, 'New');
```

- [ ] **Step 2: Verify**

```sql
SELECT title, location_name FROM public.meetups;
```

Expected: 3 rows.

---

### Task 3: meetup_participants table

**FE screen:** `meetup_screen.dart` (join/leave button, participant avatars)

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table**

```sql
CREATE TABLE public.meetup_participants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meetup_id UUID NOT NULL REFERENCES public.meetups(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  UNIQUE(meetup_id, user_id)
);

ALTER TABLE public.meetup_participants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Participants viewable by authenticated"
  ON public.meetup_participants FOR SELECT TO authenticated USING (true);

CREATE POLICY "Users can join meetups"
  ON public.meetup_participants FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can leave meetups"
  ON public.meetup_participants FOR DELETE TO authenticated
  USING (auth.uid() = user_id);
```

- [ ] **Step 2: Verify**

```sql
SELECT * FROM public.meetup_participants LIMIT 1;
```

Expected: empty table, no errors.

---

### Task 4: courses table

**FE screen:** `course_detail.dart` (course title, mentor info)

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table + seed data**

```sql
CREATE TABLE public.courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  thumbnail_url TEXT,
  mentor_name TEXT NOT NULL,
  mentor_avatar_url TEXT,
  mentor_bio TEXT,
  duration_text TEXT,
  total_lessons INT DEFAULT 0,
  rating REAL DEFAULT 4.8,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Courses viewable by authenticated"
  ON public.courses FOR SELECT TO authenticated USING (true);

-- Seed: course untuk demo video YouTube
INSERT INTO public.courses (title, description, mentor_name, mentor_bio, duration_text, total_lessons, rating) VALUES
  ('Introduction to Flutter', 'Belajar dasar-dasar Flutter dari nol sampai bisa buat app', 'Dr. Sarah Chen', 'Senior mobile developer dengan 10+ tahun pengalaman', '6h 45m', 6, 4.9),
  ('UI/UX Design Principles', 'Kuasai prinsip desain antarmuka pengguna', 'Lisa Park', 'Lead designer di top tech company', '4h 30m', 4, 4.8),
  ('Data Science with Python', 'Pengantar analisis data dan visualisasi', 'Dr. Alex Kumar', 'Data scientist dan researcher', '5h 00m', 5, 4.7);
```

- [ ] **Step 2: Verify**

```sql
SELECT title, mentor_name FROM public.courses;
```

Expected: 3 rows.

---

### Task 5: modules table

**FE screen:** `course_detail.dart` (lesson grouping)

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table + seed data**

```sql
CREATE TABLE public.modules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  sort_order INT DEFAULT 0 NOT NULL
);

ALTER TABLE public.modules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Modules viewable by authenticated"
  ON public.modules FOR SELECT TO authenticated USING (true);

-- Modules for "Introduction to Flutter"
INSERT INTO public.modules (course_id, title, sort_order) VALUES
  ((SELECT id FROM public.courses WHERE title = 'Introduction to Flutter'), 'Getting Started', 1),
  ((SELECT id FROM public.courses WHERE title = 'Introduction to Flutter'), 'Widgets', 2);
```

- [ ] **Step 2: Verify**

```sql
SELECT title FROM public.modules;
```

Expected: 2 rows.

---

### Task 6: lessons table (with YouTube video)

**FE screen:** `course_detail.dart` (YouTube player, lesson list)

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table + seed data**

```sql
CREATE TABLE public.lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id UUID NOT NULL REFERENCES public.modules(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  duration_text TEXT,
  youtube_video_id TEXT,  -- contoh: '3kaGC_DrUnw' (tanpa full URL)
  sort_order INT DEFAULT 0 NOT NULL
);

ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lessons viewable by authenticated"
  ON public.lessons FOR SELECT TO authenticated USING (true);

-- Lessons for "Getting Started" module
-- Video source: YouTube free tutorials
INSERT INTO public.lessons (module_id, title, duration_text, youtube_video_id, sort_order) VALUES
  ((SELECT id FROM public.modules WHERE title = 'Getting Started'),
   'What is Flutter?', '15:20 mins', '3kaGC_DrUnw', 1),
  ((SELECT id FROM public.modules WHERE title = 'Getting Started'),
   'Installing Flutter SDK', '12:45 mins', '3kaGC_DrUnw', 2),
  ((SELECT id FROM public.modules WHERE title = 'Getting Started'),
   'Your First Flutter App', '24:00 mins', 'DsTMhjaRQws', 3);

-- Lessons for "Widgets" module
INSERT INTO public.lessons (module_id, title, duration_text, youtube_video_id, sort_order) VALUES
  ((SELECT id FROM public.modules WHERE title = 'Widgets'),
   'StatelessWidget Deep Dive', '18:30 mins', 'DsTMhjaRQws', 1),
  ((SELECT id FROM public.modules WHERE title = 'Widgets'),
   'StatefulWidget', '22:10 mins', 'VPvVD8t02U8', 2),
  ((SELECT id FROM public.modules WHERE title = 'Widgets'),
   'Layouts: Row, Column, Stack', '20:00 mins', 'VPvVD8t02U8', 3);
```

**YouTube video IDs used:**
- `3kaGC_DrUnw` — "The Ultimate Flutter Tutorial for Beginners - 2025 Full Course"
- `DsTMhjaRQws` — "Flutter Course for Absolute Beginners"
- `VPvVD8t02U8` — "Flutter Full Course for Beginners – 37-hour Cross Platform Course"

- [ ] **Step 2: Verify**

```sql
SELECT l.title, l.youtube_video_id, m.title as module_name
  FROM public.lessons l JOIN public.modules m ON m.id = l.module_id;
```

Expected: 6 rows, each with a YouTube video ID.

---

### Task 7: quizzes table

**FE screen:** `quiz_evoluation_screen.dart`

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table + seed data**

```sql
CREATE TABLE public.quizzes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  time_limit_seconds INT DEFAULT 300,
  passing_score REAL DEFAULT 70.0,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Quizzes viewable by authenticated"
  ON public.quizzes FOR SELECT TO authenticated USING (true);

INSERT INTO public.quizzes (course_id, title, time_limit_seconds) VALUES
  ((SELECT id FROM public.courses WHERE title = 'Introduction to Flutter'), 'Flutter Basics Quiz', 300),
  ((SELECT id FROM public.courses WHERE title = 'Introduction to Flutter'), 'Widgets Quiz', 300);
```

- [ ] **Step 2: Verify**

```sql
SELECT title FROM public.quizzes;
```

Expected: 2 rows.

---

### Task 8: quiz_questions table

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table + seed data**

```sql
CREATE TABLE public.quiz_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  question_text TEXT NOT NULL,
  sort_order INT DEFAULT 0 NOT NULL
);

ALTER TABLE public.quiz_questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Quiz questions viewable by authenticated"
  ON public.quiz_questions FOR SELECT TO authenticated USING (true);

-- Questions for "Flutter Basics Quiz"
INSERT INTO public.quiz_questions (quiz_id, question_text, sort_order) VALUES
  ((SELECT id FROM public.quizzes WHERE title = 'Flutter Basics Quiz'), 'What command creates a new Flutter project?', 1),
  ((SELECT id FROM public.quizzes WHERE title = 'Flutter Basics Quiz'), 'What programming language does Flutter use?', 2),
  ((SELECT id FROM public.quizzes WHERE title = 'Flutter Basics Quiz'), 'What does "flutter doctor" do?', 3),
  ((SELECT id FROM public.quizzes WHERE title = 'Flutter Basics Quiz'), 'Which widget is the root of every Flutter app?', 4);

-- Questions for "Widgets Quiz"
INSERT INTO public.quiz_questions (quiz_id, question_text, sort_order) VALUES
  ((SELECT id FROM public.quizzes WHERE title = 'Widgets Quiz'), 'What is the base class for stateless widgets?', 1),
  ((SELECT id FROM public.quizzes WHERE title = 'Widgets Quiz'), 'Which method must be overridden in StatelessWidget?', 2),
  ((SELECT id FROM public.quizzes WHERE title = 'Widgets Quiz'), 'What widget creates a scrollable list?', 3);
```

- [ ] **Step 2: Verify**

```sql
SELECT question_text FROM public.quiz_questions;
```

Expected: 7 rows.

---

### Task 9: quiz_options table

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create table + seed data**

```sql
CREATE TABLE public.quiz_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES public.quiz_questions(id) ON DELETE CASCADE,
  option_text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT false,
  sort_order INT DEFAULT 0 NOT NULL
);

ALTER TABLE public.quiz_options ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Quiz options viewable by authenticated"
  ON public.quiz_options FOR SELECT TO authenticated USING (true);

-- Options for Q1: "What command creates a new Flutter project?"
INSERT INTO public.quiz_options (question_id, option_text, is_correct, sort_order) VALUES
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What command creates a new Flutter project?'), 'flutter create my_app', true, 1),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What command creates a new Flutter project?'), 'flutter new my_app', false, 2),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What command creates a new Flutter project?'), 'flutter init my_app', false, 3),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What command creates a new Flutter project?'), 'flutter start my_app', false, 4);

-- Options for Q2: "What programming language does Flutter use?"
INSERT INTO public.quiz_options (question_id, option_text, is_correct, sort_order) VALUES
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What programming language does Flutter use?'), 'Dart', true, 1),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What programming language does Flutter use?'), 'JavaScript', false, 2),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What programming language does Flutter use?'), 'Kotlin', false, 3),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What programming language does Flutter use?'), 'Swift', false, 4);

-- Options for Q3: "What does flutter doctor do?"
INSERT INTO public.quiz_options (question_id, option_text, is_correct, sort_order) VALUES
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What does "flutter doctor" do?'), 'Checks Flutter installation status', true, 1),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What does "flutter doctor" do?'), 'Installs Flutter SDK', false, 2),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What does "flutter doctor" do?'), 'Updates Flutter packages', false, 3),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What does "flutter doctor" do?'), 'Cleans build cache', false, 4);

-- Options for Q4: "Which widget is the root of every Flutter app?"
INSERT INTO public.quiz_options (question_id, option_text, is_correct, sort_order) VALUES
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'Which widget is the root of every Flutter app?'), 'MaterialApp or CupertinoApp', true, 1),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'Which widget is the root of every Flutter app?'), 'Scaffold', false, 2),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'Which widget is the root of every Flutter app?'), 'Container', false, 3),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'Which widget is the root of every Flutter app?'), 'ListView', false, 4);

-- Options for Q5: "What is the base class for stateless widgets?"
INSERT INTO public.quiz_options (question_id, option_text, is_correct, sort_order) VALUES
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What is the base class for stateless widgets?'), 'StatelessWidget', true, 1),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What is the base class for stateless widgets?'), 'StatefulWidget', false, 2),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What is the base class for stateless widgets?'), 'Widget', false, 3),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What is the base class for stateless widgets?'), 'InheritedWidget', false, 4);

-- Options for Q6: "Which method must be overridden in StatelessWidget?"
INSERT INTO public.quiz_options (question_id, option_text, is_correct, sort_order) VALUES
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'Which method must be overridden in StatelessWidget?'), 'build()', true, 1),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'Which method must be overridden in StatelessWidget?'), 'initState()', false, 2),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'Which method must be overridden in StatelessWidget?'), 'setState()', false, 3),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'Which method must be overridden in StatelessWidget?'), 'dispose()', false, 4);

-- Options for Q7: "What widget creates a scrollable list?"
INSERT INTO public.quiz_options (question_id, option_text, is_correct, sort_order) VALUES
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What widget creates a scrollable list?'), 'ListView', true, 1),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What widget creates a scrollable list?'), 'Column', false, 2),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What widget creates a scrollable list?'), 'Row', false, 3),
  ((SELECT id FROM public.quiz_questions WHERE question_text = 'What widget creates a scrollable list?'), 'Stack', false, 4);
```

- [ ] **Step 2: Verify**

```sql
SELECT count(*) FROM public.quiz_options;
```

Expected: 28 rows (4 options × 7 questions).

---

### Task 10: quiz_attempts + quiz_answers tables

**Files:**
- Supabase SQL Editor

- [ ] **Step 1: Create both tables**

```sql
CREATE TABLE public.quiz_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  score REAL NOT NULL DEFAULT 0,
  passed BOOLEAN NOT NULL DEFAULT false,
  started_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  completed_at TIMESTAMPTZ
);

ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users view own attempts"
  ON public.quiz_attempts FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users create attempts"
  ON public.quiz_attempts FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users update own attempts"
  ON public.quiz_attempts FOR UPDATE TO authenticated
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- quiz_answers
CREATE TABLE public.quiz_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id UUID NOT NULL REFERENCES public.quiz_attempts(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.quiz_questions(id) ON DELETE CASCADE,
  selected_option_id UUID REFERENCES public.quiz_options(id) ON DELETE SET NULL,
  is_correct BOOLEAN NOT NULL DEFAULT false,
  UNIQUE(attempt_id, question_id)
);

ALTER TABLE public.quiz_answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users view own answers"
  ON public.quiz_answers FOR SELECT TO authenticated
  USING (attempt_id IN (SELECT id FROM public.quiz_attempts WHERE user_id = auth.uid()));

CREATE POLICY "Users insert own answers"
  ON public.quiz_answers FOR INSERT TO authenticated
  WITH CHECK (attempt_id IN (SELECT id FROM public.quiz_attempts WHERE user_id = auth.uid()));
```

- [ ] **Step 2: Verify**

```sql
SELECT * FROM public.quiz_attempts LIMIT 1;
SELECT * FROM public.quiz_answers LIMIT 1;
```

Expected: both empty, no errors.

---

## PHASE 2: Flutter Packages

### Task 11: Add flutter_map + youtube_player_flutter

**Files:**
- `pubspec.yaml`

- [ ] **Step 1: Add dependencies**

Add to `pubspec.yaml` under `dependencies:`:

```yaml
  flutter_map: ^7.0.0
  latlong2: ^0.9.1
  youtube_player_flutter: ^9.1.1
```

- [ ] **Step 2: Install**

Run: `flutter pub get`

Expected: packages resolved successfully.

---

## PHASE 3: FE Models

### Task 12: Create meetup_model.dart

**Files:**
- Create: `lib/models/meetup_model.dart`

- [ ] **Step 1: Create model**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class Meetup {
  final String id;
  final String title;
  final String? description;
  final String locationName;
  final double latitude;
  final double longitude;
  final DateTime eventDate;
  final int maxParticipants;
  final String tag;
  final int participantCount;
  final bool isJoined;

  const Meetup({
    required this.id,
    required this.title,
    this.description,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.eventDate,
    required this.maxParticipants,
    required this.tag,
    this.participantCount = 0,
    this.isJoined = false,
  });

  factory Meetup.fromJson(Map<String, dynamic> json) {
    return Meetup(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      locationName: json['location_name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      eventDate: DateTime.parse(json['event_date'] as String),
      maxParticipants: json['max_participants'] as int? ?? 30,
      tag: json['tag'] as String? ?? 'Upcoming',
      participantCount: (json['participant_count'] as int?) ?? 0,
      isJoined: json['is_joined'] as bool? ?? false,
    );
  }
}
```

- [ ] **Step 2: Verify** — Run `flutter analyze`

---

### Task 13: Create course_model.dart

**Files:**
- Create: `lib/models/course_model.dart`

- [ ] **Step 1: Create model**

```dart
class Module {
  final String id;
  final String title;
  final List<Lesson> lessons;

  const Module({required this.id, required this.title, this.lessons = const []});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] as String,
      title: json['title'] as String,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String? durationText;
  final String? youtubeVideoId;
  final int sortOrder;

  const Lesson({
    required this.id,
    required this.title,
    this.durationText,
    this.youtubeVideoId,
    this.sortOrder = 0,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      durationText: json['duration_text'] as String?,
      youtubeVideoId: json['youtube_video_id'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class Course {
  final String id;
  final String title;
  final String? description;
  final String mentorName;
  final String? mentorBio;
  final String? durationText;
  final int totalLessons;
  final double rating;
  final List<Module> modules;

  const Course({
    required this.id,
    required this.title,
    this.description,
    required this.mentorName,
    this.mentorBio,
    this.durationText,
    this.totalLessons = 0,
    this.rating = 4.8,
    this.modules = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      mentorName: json['mentor_name'] as String,
      mentorBio: json['mentor_bio'] as String?,
      durationText: json['duration_text'] as String?,
      totalLessons: json['total_lessons'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      modules: (json['modules'] as List<dynamic>?)
              ?.map((e) => Module.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
```

- [ ] **Step 2: Verify** — Run `flutter analyze`

---

### Task 14: Create quiz_model.dart

**Files:**
- Create: `lib/models/quiz_model.dart`

- [ ] **Step 1: Create model**

```dart
class QuizOption {
  final String id;
  final String optionText;
  final bool isCorrect;
  final int sortOrder;

  const QuizOption({
    required this.id,
    required this.optionText,
    required this.isCorrect,
    this.sortOrder = 0,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as String,
      optionText: json['option_text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class QuizQuestion {
  final String id;
  final String questionText;
  final List<QuizOption> options;
  final int sortOrder;

  const QuizQuestion({
    required this.id,
    required this.questionText,
    this.options = const [],
    this.sortOrder = 0,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      questionText: json['question_text'] as String,
      options: (json['quiz_options'] as List<dynamic>?)
              ?.map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class Quiz {
  final String id;
  final String title;
  final int timeLimitSeconds;
  final double passingScore;
  final List<QuizQuestion> questions;

  const Quiz({
    required this.id,
    required this.title,
    this.timeLimitSeconds = 300,
    this.passingScore = 70.0,
    this.questions = const [],
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      timeLimitSeconds: json['time_limit_seconds'] as int? ?? 300,
      passingScore: (json['passing_score'] as num?)?.toDouble() ?? 70.0,
      questions: (json['quiz_questions'] as List<dynamic>?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
```

- [ ] **Step 2: Verify** — Run `flutter analyze`

---

## PHASE 4: FE Screens

### Task 15: Update meetup_screen.dart — OSM map + Supabase data

**Files:**
- Modify: `lib/screen/meetup_screen.dart`

**What changes:**
1. Replace `_buildMapSection()` dummy `Image.network` with `FlutterMap` widget using OSM tiles
2. Add `initState` to fetch meetups from Supabase
3. Replace hardcoded `_buildMeetupCard` calls with dynamic list from `meetups` table
4. Add join/leave functionality via `meetup_participants` table
5. Show real markers on map from meetup latitude/longitude

- [ ] **Step 1: Add imports at top of file**

```dart
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../models/meetup_model.dart';
```

- [ ] **Step 2: Add state variables**

```dart
List<Meetup> _meetups = [];
bool _isLoading = true;
```

- [ ] **Step 3: Add initState to fetch data**

```dart
@override
void initState() {
  super.initState();
  _fetchMeetups();
}

Future<void> _fetchMeetups() async {
  final userId = supabase.auth.currentUser?.id;
  final data = await supabase
      .from('meetups')
      .select('*, meetup_participants(count)')
      .order('event_date');
  final meetups = (data as List).map((json) {
    final participantCount = (json['meetup_participants'] as List?)?.length ?? 0;
    return Meetup.fromJson({...json, 'participant_count': participantCount});
  }).toList();
  if (!mounted) return;
  setState(() {
    _meetups = meetups;
    _isLoading = false;
  });
}
```

- [ ] **Step 4: Replace `_buildMapSection` with FlutterMap**

Replace the entire `_buildMapSection()` method with:

```dart
Widget _buildMapSection() {
  return Transform.translate(
    offset: const Offset(0, -24),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 192,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(-6.1862, 106.7996), // Jakarta Barat
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.comstudyapp',
              ),
              MarkerLayer(
                markers: _meetups.map((m) => Marker(
                  point: LatLng(m.latitude, m.longitude),
                  width: 32,
                  height: 32,
                  child: Container(
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.location_on, color: Colors.white, size: 16),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
```

- [ ] **Step 5: Replace `_buildNearbyMeetups` with dynamic data**

Replace hardcoded meetup cards with a `ListView.builder` using `_meetups` list. Map fields:
- `meetup.title` → card title
- `meetup.locationName` → card date/location line
- `meetup.tag` → tag text (Live/Offline/New)
- `meetup.participantCount` → "+N" count
- Join button → calls `supabase.from('meetup_participants').insert(...)`

- [ ] **Step 6: Add join meetup method**

```dart
Future<void> _toggleJoin(Meetup meetup) async {
  final userId = supabase.auth.currentUser!.id;
  if (meetup.isJoined) {
    await supabase
        .from('meetup_participants')
        .delete()
        .eq('meetup_id', meetup.id)
        .eq('user_id', userId);
  } else {
    await supabase.from('meetup_participants').insert({
      'meetup_id': meetup.id,
      'user_id': userId,
    });
  }
  _fetchMeetups();
}
```

- [ ] **Step 7: Run `flutter analyze`**

Expected: no errors.

---

### Task 16: Update course_detail.dart — YouTube player

**Files:**
- Modify: `lib/screen/course_detail.dart`

**What changes:**
1. Accept `courseId` parameter
2. Fetch course with modules + lessons from Supabase
3. Replace `_buildVideoPlayer()` dummy with `YoutubePlayer`
4. Replace hardcoded lessons with dynamic list from DB
5. Tap lesson → load that lesson's YouTube video

- [ ] **Step 1: Add course ID parameter + imports**

```dart
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../models/course_model.dart';
```

Change class declaration:

```dart
class CourseDetailScreen extends StatefulWidget {
  final String? courseId;
  const CourseDetailScreen({super.key, this.courseId});
  // ...
}
```

- [ ] **Step 2: Add state variables**

```dart
Course? _course;
String? _activeVideoId;
late YoutubePlayerController _youtubeController;
bool _isLoading = true;

@override
void initState() {
  super.initState();
  _youtubeController = YoutubePlayerController(
    initialVideoId: '',
    flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
  );
  if (widget.courseId != null) {
    _fetchCourse();
  } else {
    setState(() => _isLoading = false);
  }
}

@override
void dispose() {
  _youtubeController.dispose();
  super.dispose();
}
```

- [ ] **Step 3: Add fetch method**

```dart
Future<void> _fetchCourse() async {
  final data = await supabase
      .from('courses')
      .select('*, modules(*, lessons(*))')
      .eq('id', widget.courseId!)
      .single();
  final course = Course.fromJson(data);
  final firstVideo = course.modules
      .expand((m) => m.lessons)
      .firstWhere((l) => l.youtubeVideoId != null,
          orElse: () => const Lesson(id: '', title: ''));
  if (firstVideo.youtubeVideoId != null) {
    _youtubeController.load(firstVideo.youtubeVideoId!);
  }
  if (!mounted) return;
  setState(() {
    _course = course;
    _isLoading = false;
  });
}
```

- [ ] **Step 4: Replace `_buildVideoPlayer()` with YoutubePlayer**

```dart
Widget _buildVideoPlayer() {
  return YoutubePlayer(
    controller: _youtubeController,
    showVideoProgressIndicator: true,
    progressIndicatorColor: primary,
    onReady: () {},
  );
}
```

- [ ] **Step 5: Replace hardcoded lessons with dynamic list**

Replace `_buildMaterialsContent()` hardcoded lesson calls with a loop over `_course!.modules` and their `lessons`. Keep the 3 visual states (completed/active/locked) as dummy — just show lesson title + duration from DB.

Tap a lesson → call `_youtubeController.load(lesson.youtubeVideoId!)`.

- [ ] **Step 6: Update course title/nav from `_course` data**

Replace hardcoded "The Academic Atelier" and "Mastering the Editorial Aesthetic" with `_course?.title` and `_course?.mentorName`.

- [ ] **Step 7: Run `flutter analyze`**

Expected: no errors.

---

### Task 17: Update quiz_evoluation_screen.dart — Full quiz flow

**Files:**
- Modify: `lib/screen/quiz_evoluation_screen.dart`

**What changes:**
1. Accept `quizId` parameter
2. Fetch quiz with questions + options from Supabase
3. Replace hardcoded question/options with real data
4. Track answers, calculate score
5. Submit attempt + answers to Supabase on completion
6. Show real score after finishing

- [ ] **Step 1: Add imports + parameter**

```dart
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../models/quiz_model.dart';
```

```dart
class QuizEvaluationScreen extends StatefulWidget {
  final String? quizId;
  const QuizEvaluationScreen({super.key, this.quizId});
  // ...
}
```

- [ ] **Step 2: Add state variables**

```dart
Quiz? _quiz;
List<QuizQuestion> get _questions => _quiz?.questions ?? [];
int _currentIndex = 0;
String? _selectedOptionId;
int _score = 0;
int _totalCorrect = 0;
bool _isLoading = true;
bool _isCompleted = false;
Timer? _timer;
int _remainingSeconds = 300;
String? _attemptId;
```

- [ ] **Step 3: Add initState + fetch + timer**

```dart
@override
void initState() {
  super.initState();
  if (widget.quizId != null) {
    _fetchQuiz();
  } else {
    setState(() => _isLoading = false);
  }
}

@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

Future<void> _fetchQuiz() async {
  final data = await supabase
      .from('quizzes')
      .select('*, quiz_questions(*, quiz_options(*))')
      .eq('id', widget.quizId!)
      .single();
  final quiz = Quiz.fromJson(data);
  _remainingSeconds = quiz.timeLimitSeconds;
  _startTimer();
  // Create attempt
  final userId = supabase.auth.currentUser!.id;
  final attempt = await supabase.from('quiz_attempts').insert({
    'user_id': userId,
    'quiz_id': widget.quizId,
  }).select().single();
  if (!mounted) return;
  setState(() {
    _quiz = quiz;
    _attemptId = attempt['id'] as String;
    _isLoading = false;
  });
}

void _startTimer() {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_remainingSeconds > 0) {
      setState(() => _remainingSeconds--);
    } else {
      timer.cancel();
      _submitQuiz();
    }
  });
}
```

- [ ] **Step 4: Update `_buildProgressAndTimer` with real data**

Replace hardcoded "04 / 12" with `${_currentIndex + 1} / ${_questions.length}`.
Replace "00:45" with formatted `_remainingSeconds`.
Replace progress bar widthFactor with `(_currentIndex + 1) / _questions.length`.

- [ ] **Step 5: Update `_buildQuestion` with real question text**

```dart
Widget _buildQuestion() {
  if (_questions.isEmpty) return const SizedBox.shrink();
  return Text(
    _questions[_currentIndex].questionText,
    style: const TextStyle(
      color: AppColors.onSurface,
      fontFamily: 'Manrope',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
  );
}
```

- [ ] **Step 6: Update `_buildOptions` with real options**

Replace hardcoded options list with `_questions[_currentIndex].options`. Use `option.id` for tracking selection, `option.optionText` for display, letters A/B/C/D from index.

- [ ] **Step 7: Update `_buildNextButton` logic**

```dart
onTap: () {
  if (_currentIndex < _questions.length - 1) {
    setState(() {
      _currentIndex++;
      _selectedOptionId = null;
    });
  } else {
    _submitQuiz();
  }
},
```

- [ ] **Step 8: Add submit method**

```dart
Future<void> _submitQuiz() async {
  _timer?.cancel();
  final scorePercent = _questions.isNotEmpty
      ? (_totalCorrect / _questions.length * 100)
      : 0.0;
  await supabase.from('quiz_attempts').update({
    'score': scorePercent,
    'passed': scorePercent >= (_quiz?.passingScore ?? 70),
    'completed_at': DateTime.now().toIso8601String(),
  }).eq('id', _attemptId!);
  if (!mounted) return;
  setState(() => _isCompleted = true);
}
```

- [ ] **Step 9: Update `_buildScorePill` with real score**

Replace "SCORE: 320 PTS" with `"SCORE: ${_totalCorrect}/${_questions.length}"`.

- [ ] **Step 10: Run `flutter analyze`**

Expected: no errors.

---

## PHASE 5: Wire Up Navigation

### Task 18: Connect screens with course/quiz IDs

**Files:**
- Modify: `lib/screen/courses_screen.dart` (pass courseId on tap)
- Modify: `lib/screen/course_detail.dart` (add quiz button that navigates to quiz screen with quizId)

- [ ] **Step 1: In courses_screen.dart**, pass a course ID when navigating:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const CourseDetailScreen(courseId: 'COURSE_ID_HERE')),
);
```

For demo purposes, hardcode the Flutter course ID (grab from Supabase after seeding).

- [ ] **Step 2: In course_detail.dart**, add a "Take Quiz" button that navigates:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => QuizEvaluationScreen(quizId: quizId)),
);
```

Fetch quiz ID from `quizzes` table filtered by `course_id`.

- [ ] **Step 3: Run `flutter analyze`**

Expected: no errors.

---

## Verification

### BE Verification (Supabase SQL Editor)

```sql
SELECT 'profiles' as tbl, count(*) FROM public.profiles
UNION ALL SELECT 'meetups', count(*) FROM public.meetups
UNION ALL SELECT 'meetup_participants', count(*) FROM public.meetup_participants
UNION ALL SELECT 'courses', count(*) FROM public.courses
UNION ALL SELECT 'modules', count(*) FROM public.modules
UNION ALL SELECT 'lessons', count(*) FROM public.lessons
UNION ALL SELECT 'quizzes', count(*) FROM public.quizzes
UNION ALL SELECT 'quiz_questions', count(*) FROM public.quiz_questions
UNION ALL SELECT 'quiz_options', count(*) FROM public.quiz_options
UNION ALL SELECT 'quiz_attempts', count(*) FROM public.quiz_attempts
UNION ALL SELECT 'quiz_answers', count(*) FROM public.quiz_answers;
```

Expected: all tables return counts, no "relation does not exist" errors.

### FE Verification

Run: `flutter analyze`

Expected: no errors.

### Demo Flow

1. Login/register → profile auto-created
2. Tap meetup tab → OSM map with 3 markers → tap "Join" → participant saved
3. Tap course → YouTube video plays → tap lesson → video changes
4. Tap "Take Quiz" → answer questions → submit → score saved

---

## Cleanup (after implementation)

Remove dead code files:
- `lib/models/post_model.dart` — replaced by `forum_model.dart`
- `lib/models/reply_model.dart` — replaced by `forum_model.dart`
- `lib/services/post_service.dart` — replaced by direct `supabase` calls
- `lib/models/user_model.dart` — never used
