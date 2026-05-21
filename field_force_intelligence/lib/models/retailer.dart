class Retailer {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String inventoryLevel;
  final int priorityScore;
  final DateTime lastVisited;

  Retailer({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.inventoryLevel,
    required this.priorityScore,
    required this.lastVisited,
  });

  factory Retailer.fromMap(Map<String, dynamic> map) {
    return Retailer(
      id: map['id'] as String,
      name: map['name'] as String,
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
      inventoryLevel: map['inventory_level'] as String,
      priorityScore: map['priority_score'] as int,
      lastVisited: DateTime.parse(map['last_visited'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lng': lng,
      'inventory_level': inventoryLevel,
      'priority_score': priorityScore,
      'last_visited': lastVisited.toIso8601String(),
    };
  }
}
