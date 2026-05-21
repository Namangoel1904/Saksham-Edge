class PestAlert {
  final String id;
  final String region;
  final String severity;
  final String crop;

  PestAlert({
    required this.id,
    required this.region,
    required this.severity,
    required this.crop,
  });

  factory PestAlert.fromMap(Map<String, dynamic> map) {
    return PestAlert(
      id: map['id'] as String,
      region: map['region'] as String,
      severity: map['severity'] as String,
      crop: map['crop'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'region': region,
      'severity': severity,
      'crop': crop,
    };
  }
}
