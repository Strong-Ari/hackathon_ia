import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_models.dart';
import '../services/chat_service.dart';

// Provider pour l'état des conversations
class ChatNotifier extends StateNotifier<List<ChatConversation>> {
  final ChatService _chatService;

  ChatNotifier(this._chatService) : super([]);

  // Créer une nouvelle conversation
  void createConversation(ChatClient client) {
    final conversation = _chatService.createConversation(client);
    state = [...state, conversation];
  }

  // Envoyer un message
  Future<void> sendMessage(String conversationId, String content) async {
    await _chatService.sendMessage(conversationId, content);
    _refreshConversations();
  }

  // Envoyer une réponse automatique
  Future<void> sendAutoResponse(String conversationId) async {
    await _chatService.sendAutoResponse(conversationId);
    _refreshConversations();
  }

  // Fermer une conversation
  void closeConversation(String conversationId) {
    _chatService.closeConversation(conversationId);
    _refreshConversations();
  }

  // Supprimer une conversation
  void deleteConversation(String conversationId) {
    _chatService.deleteConversation(conversationId);
    _refreshConversations();
  }

  // Obtenir une conversation spécifique
  ChatConversation? getConversation(String conversationId) {
    try {
      return state.firstWhere((c) => c.id == conversationId);
    } catch (e) {
      return null;
    }
  }

  // Actualiser la liste des conversations
  void _refreshConversations() {
    state = _chatService.getAllConversations();
  }
}

// Provider pour les conversations
final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatConversation>>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatNotifier(chatService);
});

// Provider pour une conversation spécifique
final conversationProvider = Provider.family<ChatConversation?, String>((ref, conversationId) {
  final conversations = ref.watch(chatProvider);
  try {
    return conversations.firstWhere((c) => c.id == conversationId);
  } catch (e) {
    return null;
  }
});