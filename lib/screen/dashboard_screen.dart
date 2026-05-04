import 'package:comstudyapp/screen/meetup_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import 'package:comstudyapp/screen/courses_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Color background = AppColors.background;
  final Color onBackground = AppColors.onBackground;
  final Color primaryContainer = AppColors.primaryContainer;
  final Color primary = AppColors.primary;
  final Color secondary = AppColors.secondary;
  final Color tertiary = AppColors.tertiary;
  final Color onSurface = AppColors.onSurface;

  String _username = "User";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Simulasi pengambilan data user dari server
    final user = Supabase.instance.client.auth.currentUser;
    if(user != null){
      setState(() {
        _username = user.userMetadata?['username'] ?? user.email ?? 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchBar(),
                _buildCategories(),
                _buildProgress(),
                _buildUpcomingMeetups(),
              ],
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopNav()),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC2F_7STGrmM1g3gHorAaPLmhkfcLq_zHAK045pmz5HDfVPLQSM71l7cgIaeUvBspd9VbU7o-67LYOCO8SIWqfUn0jcg95DeHB-KkSYahVjmXJOLDgGvpMSTuu9jUrgwoTTkyoEcOctUMXomnef8Y09ZEhvcgGikwdax_wtxHZyeYPAFVanXMAkIRfzQ3v-g7KyGH44csDHIc7fZJ002zw8IWJMxeWM3DNOq8GOkCc4vDnVmjY66GG4BjYBVNGcz7McsoI7_Klio29S',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WELCOME BACK,',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    _username,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.search, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3E2E6),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.search, color: onBackground.withOpacity(0.6)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search for courses, mentors...',
                style: TextStyle(
                  color: onBackground.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      color: Color(0xFF26487A),
                      fontFamily: 'Manrope',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: Color(0xFF26487A),
                      fontFamily: 'Manrope',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'SEE ALL',
                style: TextStyle(
                  color: secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _buildCategoryCard('Tech', Icons.code, primaryContainer),
                const SizedBox(width: 16),
                _buildCategoryCard('Business', Icons.trending_up, secondary),
                const SizedBox(width: 16),
                _buildCategoryCard('Design', Icons.palette, tertiary),
                const SizedBox(width: 16),
                _buildCategoryCard('Science', Icons.biotech, primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color iconColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CoursesScreen()),
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3F7),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: onSurface,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: TextStyle(
              color: primary,
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDUT-4CSGsgztCenfy-dM87kMxd8zsRlZS_Q-2IQLmmGj6hDelkoKdmM75CfSE8jD-o2m8I1BMy7DjSKTKG8gfUGMA2C9oU5Wj-ixS_qpYIdecoDNA0sBjwT_o0L89vbBrmRrX6ZoRrvJ6o13_oL1h5Wgqb_ilJvNpwChCDBR9hSMEmq19U_rDuCbi-cnHf72_FytCvhw7q1T2Bwv8COl0-LPDGe8yIARZ-v0pWscX1tYsMPFZdPRcbcPT19wd3KTmXigM0jqk7Svv6',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB3F48B).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'CONTINUING',
                              style: TextStyle(
                                color: Color(0xFF205200),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Advanced UI Patterns',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Module 4: Cognitive Ergonomics',
                            style: TextStyle(
                              color: onBackground.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '72% Completed',
                      style: TextStyle(
                        color: onBackground.withOpacity(0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '12/16 Lessons',
                      style: TextStyle(
                        color: onBackground.withOpacity(0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 8,
                    color: const Color(0xFFE3E2E6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 72,
                          child: Container(color: const Color(0xFF98D772)),
                        ),
                        Expanded(flex: 28, child: Container()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMeetups() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Meetups',
            style: TextStyle(
              color: primary,
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF799),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFF799).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: onBackground.withOpacity(0.6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Oct 24 • 18:30 PM',
                          style: TextStyle(
                            color: onBackground.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 80),
                      child: Text(
                        'Design Critique: The Future of EdTech',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildAvatarStack([
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD9K-OBFWZHv1hRY4_YzdK9S4y_-RVYufk-7xWMsv4GLMZQGPVPnoRurv_3TrNjGymHLU2sPBaD4PmISp2JDr5Jn3nn7R8a2Yg7YJWiMHDmM0tafOwlNyDuplU6YCDARs_8fv3wveHJfvC8KfkI7BNPfw7yZn7BDEV2VlGYbBb8f7ZPcB3uWmJz1f_P7yb7cL_XBlRynxYdW6Is2mGf8NmJmUO5lcIhjweVI8lOvI_QwWgToMmzf6avlQLeu7ELhAyURlCINI7VyBG7',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCDZxWonFxshwtE8RRRaW2PObWHvKJuK_EnmBiRbxLrteYvdroJRoy5AZxR0qqR3HgaPFMwutG6u3_q-pzPGeogCOoYnTsxxovKXcSkp6nG-6vpnVtrD97APBDFb4TsDMmA4d-GJ0vLqNyevrB0IioTRDAohDBuqWoEQNCwEWIfkaxTAmb3j90WlCtnuESKNu3CIzhv9jOZrSRiwQP7H4RI9n_qxNQKtSpys_nRtQJhKW2azaSWC7Os2KTCa7joGzuGI5G4i3x6o-bb',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDNMoW4AVyXRBVftgklpVRCCBiplrN_wLWyRgPrAtcUR_hUQA4Cp2PE2m7fsfaGjK3_MpLbL6r2J3uFfabxD55vGrwXUnpl78QaZlApuBfXbFlmD4azK7UbrC6YJdEAcAjzSHpd5hiVxAyZx-P8Fznk52wui525bVa83oIgCqLgSRcUijOkZYEfS0QtZM-nJh5ouoO0_S8v9PkLew37Pyu_acoJy5JRfCLpxsPSzzdmXJdedt1uE8KmvT06gbwZRKDuHtnwLcF9R5jH',
                        ], '+14'),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 16,
                  right: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika pendaftaran disini
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MeetupScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),

                    child: const Text(
                      'Join',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Icon(
                    Icons.groups,
                    size: 100,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack(List<String> urls, String extra) {
    return Row(
      children: [
        for (int i = 0; i < urls.length; i++)
          Transform.translate(
            offset: Offset(i * -12.0, 0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFFFF799),
              child: CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(urls[i]),
              ),
            ),
          ),
        Transform.translate(
          offset: Offset(urls.length * -12.0, 0),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.1),
              border: Border.all(color: const Color(0xFFFFF799), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              extra,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
