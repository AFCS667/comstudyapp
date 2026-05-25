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

  Meetup copyWith({int? participantCount, bool? isJoined}) {
    return Meetup(
      id: id,
      title: title,
      description: description,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      eventDate: eventDate,
      maxParticipants: maxParticipants,
      tag: tag,
      participantCount: participantCount ?? this.participantCount,
      isJoined: isJoined ?? this.isJoined,
    );
  }

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
