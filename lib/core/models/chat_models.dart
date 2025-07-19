import 'package:flutter/foundation.dart';

@immutable
class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isFromProducer;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isFromProducer,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? content,
    DateTime? timestamp,
    bool? isFromProducer,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isFromProducer: isFromProducer ?? this.isFromProducer,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.id == id &&
        other.senderId == senderId &&
        other.content == content &&
        other.timestamp == timestamp &&
        other.isFromProducer == isFromProducer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        content.hashCode ^
        timestamp.hashCode ^
        isFromProducer.hashCode;
  }
}

@immutable
class ChatClient {
  final String id;
  final String name;
  final String avatar;
  final String interest;
  final String distance;
  final bool isOnline;

  const ChatClient({
    required this.id,
    required this.name,
    required this.avatar,
    required this.interest,
    required this.distance,
    this.isOnline = false,
  });

  ChatClient copyWith({
    String? id,
    String? name,
    String? avatar,
    String? interest,
    String? distance,
    bool? isOnline,
  }) {
    return ChatClient(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      interest: interest ?? this.interest,
      distance: distance ?? this.distance,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatClient &&
        other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.interest == interest &&
        other.distance == distance &&
        other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        interest.hashCode ^
        distance.hashCode ^
        isOnline.hashCode;
  }
}

@immutable
class ChatConversation {
  final String id;
  final ChatClient client;
  final List<ChatMessage> messages;
  final DateTime lastActivity;
  final bool isActive;

  const ChatConversation({
    required this.id,
    required this.client,
    required this.messages,
    required this.lastActivity,
    this.isActive = true,
  });

  ChatConversation copyWith({
    String? id,
    ChatClient? client,
    List<ChatMessage>? messages,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatConversation &&
        other.id == id &&
        other.client == client &&
        listEquals(other.messages, messages) &&
        other.lastActivity == lastActivity &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        client.hashCode ^
        messages.hashCode ^
        lastActivity.hashCode ^
        isActive.hashCode;
  }
}