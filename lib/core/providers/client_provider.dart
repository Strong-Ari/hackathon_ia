import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/client_model.dart';
import '../services/client_service.dart';

// Provider pour le service client
final clientServiceProvider = Provider<ClientService>((ref) {
  return ClientService();
});

// Provider pour l'état de recherche de clients
class ClientSearchState {
  final bool isSearching;
  final List<Client>? foundClients;
  final String? error;

  ClientSearchState({
    this.isSearching = false,
    this.foundClients,
    this.error,
  });

  ClientSearchState copyWith({
    bool? isSearching,
    List<Client>? foundClients,
    String? error,
  }) {
    return ClientSearchState(
      isSearching: isSearching ?? this.isSearching,
      foundClients: foundClients ?? this.foundClients,
      error: error ?? this.error,
    );
  }
}

class ClientSearchNotifier extends StateNotifier<ClientSearchState> {
  final ClientService _clientService;

  ClientSearchNotifier(this._clientService) : super(ClientSearchState());

  Future<void> searchNearbyClients() async {
    state = state.copyWith(isSearching: true, error: null);
    
    try {
      final clients = await _clientService.searchNearbyClients();
      state = state.copyWith(
        isSearching: false,
        foundClients: clients,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  void clearSearch() {
    state = ClientSearchState();
  }
}

final clientSearchProvider = StateNotifierProvider<ClientSearchNotifier, ClientSearchState>((ref) {
  final clientService = ref.watch(clientServiceProvider);
  return ClientSearchNotifier(clientService);
});

// Provider pour les conversations
class ConversationsNotifier extends StateNotifier<List<ChatConversation>> {
  final ClientService _clientService;

  ConversationsNotifier(this._clientService) : super([]) {
    _loadConversations();
  }

  void _loadConversations() {
    state = _clientService.getAllConversations();
  }

  void addConversation(ChatConversation conversation) {
    state = [...state, conversation];
  }

  void updateConversation(String conversationId, ChatConversation updatedConversation) {
    state = state.map((conv) {
      if (conv.id == conversationId) {
        return updatedConversation;
      }
      return conv;
    }).toList();
  }

  void removeConversation(String conversationId) {
    _clientService.deleteConversation(conversationId);
    state = state.where((conv) => conv.id != conversationId).toList();
  }

  ChatConversation? getConversation(String conversationId) {
    return _clientService.getConversation(conversationId);
  }

  Future<Message> sendMessage(String conversationId, String content) async {
    final message = await _clientService.sendMessage(conversationId, content);
    
    // Mettre à jour la conversation dans l'état
    final conversation = _clientService.getConversation(conversationId);
    if (conversation != null) {
      updateConversation(conversationId, conversation);
    }
    
    return message;
  }
}

final conversationsProvider = StateNotifierProvider<ConversationsNotifier, List<ChatConversation>>((ref) {
  final clientService = ref.watch(clientServiceProvider);
  return ConversationsNotifier(clientService);
});

// Provider pour une conversation spécifique
final conversationProvider = Provider.family<ChatConversation?, String>((ref, conversationId) {
  final conversations = ref.watch(conversationsProvider);
  return conversations.firstWhere(
    (conv) => conv.id == conversationId,
    orElse: () => null,
  );
});