class Client {
  final String id;
  final String name;
  final String? photoPath;
  final String interest;
  final String location;
  final DateTime createdAt;

  Client({
    required this.id,
    required this.name,
    this.photoPath,
    required this.interest,
    required this.location,
    required this.createdAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoPath: json['photo_path'],
      interest: json['interest'] ?? '',
      location: json['location'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['created_at'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo_path': photoPath,
      'interest': interest,
      'location': location,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  Client copyWith({
    String? id,
    String? name,
    String? photoPath,
    String? interest,
    String? location,
    DateTime? createdAt,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      interest: interest ?? this.interest,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Message {
  final String id;
  final String clientId;
  final String content;
  final bool isFromProducer;
  final DateTime timestamp;
  final MessageStatus status;

  Message({
    required this.id,
    required this.clientId,
    required this.content,
    required this.isFromProducer,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      clientId: json['client_id'] ?? '',
      content: json['content'] ?? '',
      isFromProducer: json['is_from_producer'] ?? false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      status: MessageStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'content': content,
      'is_from_producer': isFromProducer,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'status': status.name,
    };
  }

  Message copyWith({
    String? id,
    String? clientId,
    String? content,
    bool? isFromProducer,
    DateTime? timestamp,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      content: content ?? this.content,
      isFromProducer: isFromProducer ?? this.isFromProducer,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

extension MessageStatusExtension on MessageStatus {
  String get displayName {
    switch (this) {
      case MessageStatus.sending:
        return 'Envoi...';
      case MessageStatus.sent:
        return 'Envoyé';
      case MessageStatus.delivered:
        return 'Livré';
      case MessageStatus.read:
        return 'Lu';
      case MessageStatus.failed:
        return 'Échec';
    }
  }

  String get icon {
    switch (this) {
      case MessageStatus.sending:
        return '⏳';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.read:
        return '✓✓';
      case MessageStatus.failed:
        return '❌';
    }
  }
}

class ChatConversation {
  final String id;
  final Client client;
  final List<Message> messages;
  final DateTime lastActivity;
  final bool isActive;

  ChatConversation({
    required this.id,
    required this.client,
    this.messages = const [],
    required this.lastActivity,
    this.isActive = true,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? '',
      client: Client.fromJson(json['client'] ?? {}),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((m) => Message.fromJson(m))
              .toList() ??
          [],
      lastActivity: DateTime.fromMillisecondsSinceEpoch(
        json['last_activity'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': client.toJson(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'last_activity': lastActivity.millisecondsSinceEpoch,
      'is_active': isActive,
    };
  }

  ChatConversation copyWith({
    String? id,
    Client? client,
    List<Message>? messages,
    DateTime? lastActivity,
    bool? isActive,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      client: client ?? this.client,
      messages: messages ?? this.messages,
      lastActivity: lastActivity ?? this.lastActivity,
      isActive: isActive ?? this.isActive,
    );
  }
}