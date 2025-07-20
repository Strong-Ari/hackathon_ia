class NotificationModel {
  final String audioFile;
  final String? imagePath;
  final String message;
  final int timestamp;
  final String titre;

  NotificationModel({
    required this.audioFile,
    this.imagePath,
    required this.message,
    required this.timestamp,
    required this.titre,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      audioFile: json['audio_file'] ?? '',
      imagePath: json['image_path'],
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      titre: json['titre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audio_file': audioFile,
      'image_path': imagePath,
      'message': message,
      'timestamp': timestamp,
      'titre': titre,
    };
  }

  String getAudioUrl(String baseUrl) {
    return '$baseUrl/$audioFile';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp;

  @override
  int get hashCode => timestamp.hashCode;

  @override
  String toString() {
    return 'NotificationModel{audioFile: $audioFile, imagePath: $imagePath, message: $message, timestamp: $timestamp, titre: $titre}';
  }
}
