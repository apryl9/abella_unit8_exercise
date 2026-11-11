import 'dart:async';
import 'gallery_screen.dart';
import 'shelf_screen.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const fullName = 'Apryl Nine Grace S. Abella';
const tagline = 'A gentle heart. A determined mind.';
const petName = 'Panda';

const biography =
    'I am Apryl Nine Grace S. Abella from Oton, Iloilo, a third-year '
    'Bachelor of Science in Information Technology student at West '
    'Visayas State University, Main Campus in La Paz. My educational '
    'journey began at Oton Central Elementary School, continued at '
    'Iloilo Science and Technology University–Laboratory School for '
    'junior high school and PHINMA–University of Iloilo for senior '
    'high school, and brought me to WVSU for college. Although I may '
    'appear reserved and nonchalant, I am kind, loving, caring, and '
    'soft-hearted. I express my creativity through painting, drawing, '
    'sketching, and making TikTok lip-sync and dance videos. I also '
    'enjoy working out, walking, and caring for my skin. During '
    'elementary and high school, I competed in mathematics; one of '
    'my proudest achievements was winning a bronze medal in Jakarta, '
    'Indonesia, while representing the Philippines in Grade 6. '
    'My participation in poster-making and painting contests also '
    'helped nurture my love for art. Today, I share that passion by '
    'tutoring children in art for competitions and summer classes. '
    'Through creativity, learning, and helping others, I continue '
    'to grow with a gentle heart and a determined mind.';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apryl | Personal Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB76E79),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF854650),
          onPrimary: const Color(0xFFFFFFFF),
          primaryContainer: const Color(0xFFF4DDE1),
          onPrimaryContainer: const Color(0xFF45232B),
          secondaryContainer: const Color(0xFFE5B5BD),
          onSecondaryContainer: const Color(0xFF45232B),
          tertiaryContainer: const Color(0xFFF7DBCB),
          onTertiaryContainer: const Color(0xFF51352C),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.secondaryContainer,
        foregroundColor: colors.onSecondaryContainer,
        surfaceTintColor: colors.secondaryContainer,
        centerTitle: false,
        title: Text(
          _selectedIndex == 0
            ? fullName
            : _selectedIndex == 1
                ? 'My Pet — Panda'
                : _selectedIndex == 2
                    ? 'My Gallery'
                    : 'My Shelf',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: colors.primary.withValues(alpha: 0.2),
          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            ProfileScreen(),
            PetScreen(),
            GalleryScreen(),
            ShelfScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: colors.secondaryContainer,
          surfaceTintColor: colors.secondaryContainer,
          indicatorColor: colors.tertiaryContainer,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) {
              final selected =
                  states.contains(WidgetState.selected);

              return IconThemeData(
                color: selected
                    ? colors.onTertiaryContainer
                    : colors.onSecondaryContainer,
              );
            },
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) {
              final selected =
                  states.contains(WidgetState.selected);

              return (theme.textTheme.labelMedium ??
                      const TextStyle())
                  .copyWith(
                color: colors.onSecondaryContainer,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
              );
            },
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets),
              label: 'My Pet',
            ),
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              selectedIcon: Icon(Icons.photo_library),
              label: 'Gallery',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book),
              label: 'Shelf',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });
}


class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });
}


const List<String> myHobbies = [
  'Painting',
  'Drawing',
  'Sketching',
  'Working out',
  'Walking',
  'Skincare',
  'Making TikTok videos',
];



const List<ClassSlot> myClassSchedule = [
  ClassSlot(
    day: 'Monday',
    time: '7:00 AM–9:00 AM',
    subject: 'CIT 213 — Human Computer Interaction 2',
  ),
  ClassSlot(
    day: 'Monday',
    time: '9:00 AM–12:00 PM',
    subject: 'CIT 251 — Security Compliance and Governance',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '9:00 AM–12:00 PM',
    subject: 'CC 207B — Applications Development and Emerging Technologies',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '1:00 PM–2:30 PM',
    subject: 'BA 234 — Technopreneurship',
  ),
  ClassSlot(
    day: 'Wednesday',
    time: '1:00 PM–3:00 PM',
    subject: 'CIT 210 — Web Systems and Technologies',
  ),
  ClassSlot(
    day: 'Wednesday',
    time: '3:00 PM–4:00 PM',
    subject: 'CIT 212 — Networking 2 (Advanced Networking)',
  ),
  ClassSlot(
    day: 'Thursday',
    time: '10:00 AM–12:00 PM',
    subject: 'CC 207B — Applications Development and Emerging Technologies',
  ),
  ClassSlot(
    day: 'Thursday',
    time: '4:00 PM–5:30 PM',
    subject: 'CC 208 — Methods of Research in Computing',
  ),
];



class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> personalInfos = [
    ProfileInfo(
      icon: Icons.cake_outlined,
      label: 'Birthday',
      value: 'April 9, 2006',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Hometown',
      value: 'Oton, Iloilo',
    ),
    ProfileInfo(
      icon: Icons.palette_outlined,
      label: 'Creative Interests',
      value:
          'Painting, drawing, sketching, and creating '
          'TikTok lip-sync and dance videos',
    ),
    
    ProfileInfo(
      icon: Icons.restaurant_outlined,
      label: 'Favorite Foods',
      value:
          'Spicy and sour foods, fruits, sinigang na baboy, '
          'and fried chicken',
    ),
  ];

  static const List<ProfileInfo> educationInfos = [
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'College',
      value:
          'West Visayas State University — Main / La Paz Campus',
    ),
    ProfileInfo(
      icon: Icons.computer_outlined,
      label: 'Degree Program',
      value: 'Bachelor of Science in Information Technology',
    ),
    ProfileInfo(
      icon: Icons.groups_outlined,
      label: 'Year and Section',
      value: 'BSIT 3A-CBS',
    ),
    ProfileInfo(
      icon: Icons.menu_book_outlined,
      label: 'Senior High School',
      value: 'PHINMA–University of Iloilo',
    ),
    ProfileInfo(
      icon: Icons.auto_stories_outlined,
      label: 'Junior High School',
      value:
          'Iloilo Science and Technology University–Laboratory School',
    ),
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Elementary School',
      value: 'Oton Central Elementary School',
    ),
  ];

  static const List<ProfileInfo> achievementInfos = [
    ProfileInfo(
      icon: Icons.emoji_events_outlined,
      label: 'Mathematics Achievement',
      value:
          'Bronze medal in a mathematics competition in Jakarta, '
          'Indonesia, while representing the Philippines in Grade 6',
    ),
    ProfileInfo(
      icon: Icons.brush_outlined,
      label: 'Art Experience',
      value: 'Participated in poster-making and painting contests',
    ),
    ProfileInfo(
      icon: Icons.volunteer_activism_outlined,
      label: 'Sharing My Passion',
      value:
          'Tutoring children in art for competitions '
          'and summer classes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colors.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PERSONAL PROFILE',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colors.onPrimaryContainer,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.surface,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/profile.jpg',
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              semanticLabel: 'Photo of $fullName',
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style:
                                    theme.textTheme.headlineSmall
                                        ?.copyWith(
                                  color: colors.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Tooltip(
                                message: tagline,
                                child: Text(
                                  tagline,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      theme.textTheme.bodyMedium
                                          ?.copyWith(
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        ProfileBadge(
                          icon: Icons.computer_outlined,
                          label: 'IT Student',
                        ),
                        ProfileBadge(
                          icon: Icons.palette_outlined,
                          label: 'Art Enthusiast',
                        ),
                        ProfileBadge(
                          icon: Icons.fitness_center,
                          label: 'Fitness Enthusiast',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SectionHeading(
                title: 'About Me',
                subtitle:
                    'The interests and everyday details that shape me.',
              ),
              for (final info in personalInfos)
                InfoTile(info: info),
                
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Hobbies',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final hobby in myHobbies)
                              Chip(
                                avatar: const Icon(
                                  Icons.favorite_outline,
                                  size: 18,
                                ),
                                label: Text(hobby),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              
              
              const SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Class Schedule',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FixedColumnWidth(90),
                            1: FixedColumnWidth(140),
                            2: FixedColumnWidth(280),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              children: [
                                for (final heading in ['Day', 'Time', 'Subject'])
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      heading,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            for (final slot in myClassSchedule)
                              TableRow(
                                children: [
                                  for (final value in [
                                    slot.day,
                                    slot.time,
                                    slot.subject,
                                  ])
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(value),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SectionHeading(
                title: 'Educational Journey',
                subtitle: 'The schools that shaped my learning.',
              ),
              for (final info in educationInfos)
                InfoTile(info: info),
              const SectionHeading(
                title: 'Achievements and Creative Pursuits',
                subtitle:
                    'Milestones, expression, and sharing what I love.',
              ),
              
              for (final info in achievementInfos)
                InfoTile(info: info),
              const SizedBox(height: 28),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: colors.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.format_quote,
                        color: colors.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'My Biography',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        biography,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProfileBadge({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: colors.primary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.outlineVariant,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                info.icon,
                color: colors.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    info.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<void>? _completionSubscription;

  bool _isPlaying = false;
  bool _isLoved = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();

    _completionSubscription =
        _player.onPlayerComplete.listen((_) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });
    });
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
    });

    try {
      await _player.play(
        AssetSource('sounds/pet_sound.mp3'),
      );

      if (!mounted) return;

      setState(() {
        _playCount++;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not play the sound. '
            'Check assets/sounds/pet_sound.mp3.',
          ),
        ),
      );
    }
  }

  void _toggleLove() {
    setState(() {
      _isLoved = !_isLoved;
    });
  }

  
Future<void> _confirmResetCount() async {
  final shouldReset = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset bark count?'),
      content: const Text(
        'Are you sure you want to reset Panda’s bark count to zero?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Reset'),
        ),
      ],
    ),
  );

  if (shouldReset == true && mounted) {
    setState(() {
      _playCount = 0;
    });
  }
}


  @override
  void dispose() {
    _completionSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colors.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY COMPANION',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colors.onPrimaryContainer,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      petName,
                      style:
                          theme.textTheme.headlineSmall?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Meet my dog, Panda—a cherished part of my life.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onDoubleTap: _toggleLove,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.asset(
                          'assets/images/pet.jpeg',
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of Panda, my dog',
                        ),
                      ),
                      if (_isLoved)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 56,
                            color: colors.onPrimaryContainer,
                            semanticLabel: 'Panda is loved',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Double-tap the photo to show or hide a heart.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: colors.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'A Little Hello from Panda',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap below to hear Panda’s bark.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        onPressed: _isPlaying ? null : _playSound,
                        icon: Icon(
                          _isPlaying
                              ? Icons.volume_up
                              : Icons.play_arrow,
                        ),
                        label: Text(
                          _isPlaying
                              ? 'Playing...'
                              : 'Play Panda’s Bark',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(
                        color: colors.outlineVariant,
                      ),
                      const SizedBox(height: 12),
                      
                      Text(
                        '$petName has barked $_playCount '
                        '${_playCount == 1 ? 'time' : 'times'}.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),

                      OutlinedButton.icon(
                        onPressed: _playCount == 0 ? null : _confirmResetCount,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset count'),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        _isLoved
                            ? 'A little love for Panda.'
                            : 'A companion with a place in my heart.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}