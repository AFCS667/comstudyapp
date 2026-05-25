import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:comstudyapp/screen/meetup_navigation_screen.dart';
import '../main.dart';
import '../models/meetup_model.dart';
import '../theme/app_colors.dart';

class MeetupScreen extends StatefulWidget {
  const MeetupScreen({super.key});

  @override
  State<MeetupScreen> createState() => _MeetupScreenState();
}

class _MeetupScreenState extends State<MeetupScreen> {
  final Color background = AppColors.background;
  final Color onBackground = AppColors.onBackground;
  final Color primaryContainer = AppColors.primaryContainer;
  final Color primary = AppColors.primary;
  final Color highlight = AppColors.highlight;
  final Color error = AppColors.error;
  final Color onSurface = AppColors.onSurface;
  final Color tertiaryFixed = AppColors.tertiaryFixed;
  final Color tertiary = AppColors.tertiary;

  List<Meetup> _meetups = [];
  bool _isLoading = true;

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
    final meetups = <Meetup>[];
    for (final json in data as List) {
      final participantList = json['meetup_participants'] as List? ?? [];
      final participantCount = participantList.length;
      bool isJoined = false;
      if (userId != null) {
        final joinData = await supabase
            .from('meetup_participants')
            .select()
            .eq('meetup_id', json['id'] as String)
            .eq('user_id', userId);
        isJoined = joinData.isNotEmpty;
      }
      meetups.add(Meetup.fromJson({
        ...json,
        'participant_count': participantCount,
        'is_joined': isJoined,
      }));
    }
    if (!mounted) return;
    setState(() {
      _meetups = meetups;
      _isLoading = false;
    });
  }

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
                _buildHeaderSection(),
                _buildMapSection(),
                _buildNearbyMeetups(),
              ],
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopNav()),
        ],
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius:
            const BorderRadius.only(bottomRight: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(51),
                    width: 2,
                  ),
                ),
                child:
                    const Icon(Icons.person, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'Community Meetups',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(Icons.search, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        color: primaryContainer,
        borderRadius:
            const BorderRadius.only(bottomRight: Radius.circular(24)),
      ),
      padding:
          const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 48),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Meetups',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Manrope',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Connect with fellow learners in your area',
            style: TextStyle(
              color: Color(0xFFC9DBFF),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

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
              options: const MapOptions(
                initialCenter: LatLng(-6.1862, 106.7996),
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
                ),
                MarkerLayer(
                  markers: _meetups
                      .map((m) => Marker(
                            point: LatLng(m.latitude, m.longitude),
                            width: 32,
                            height: 32,
                            child: Container(
                              decoration: BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.location_on,
                                  color: Colors.white, size: 16),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyMeetups() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Meetups',
                style: TextStyle(
                  color: onBackground,
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'View Map',
                style: TextStyle(
                  color: primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ..._meetups.map((meetup) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildMeetupCard(meetup),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Color _tagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'live':
        return error;
      case 'offline':
        return onSurface.withAlpha(26);
      case 'new':
        return tertiary;
      default:
        return primary;
    }
  }

  Color _tagTextColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'live':
        return Colors.white;
      case 'offline':
        return onSurface.withAlpha(153);
      case 'new':
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  Widget _buildMeetupCard(Meetup meetup) {
    final tagColor = _tagColor(meetup.tag);
    final tagTextColor = _tagTextColor(meetup.tag);
    final bgColor =
        meetup.tag.toLowerCase() == 'new' ? tertiaryFixed : highlight;
    final titleColor =
        meetup.tag.toLowerCase() == 'new' ? const Color(0xFF082100) : onSurface;

    final day = meetup.eventDate.day.toString().padLeft(2, '0');
    final month = _monthName(meetup.eventDate.month);
    final hour = meetup.eventDate.hour.toString().padLeft(2, '0');
    final minute = meetup.eventDate.minute.toString().padLeft(2, '0');
    final dateLocation =
        '$day $month, $hour:$minute \u2022 ${meetup.locationName}';

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 64),
                child: Text(
                  meetup.title,
                  style: TextStyle(
                    color: titleColor,
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 14, color: titleColor.withAlpha(179)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dateLocation,
                      style: TextStyle(
                        color: titleColor.withAlpha(179),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: titleColor.withAlpha(26),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+${meetup.participantCount}',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (meetup.isJoined)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _toggleJoin(meetup),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: error.withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.close,
                                color: error,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          if (meetup.isJoined) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MeetupNavigationScreen(
                                  meetup: meetup,
                                ),
                              ),
                            );
                          } else {
                            _toggleJoin(meetup);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: meetup.isJoined
                              ? titleColor.withAlpha(26)
                              : onSurface,
                          foregroundColor:
                              meetup.isJoined ? titleColor : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          meetup.isJoined ? 'Navigate' : 'Join',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                meetup.tag.toUpperCase(),
                style: TextStyle(
                  color: tagTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  Widget _buildFAB() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
