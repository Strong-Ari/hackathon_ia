import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_models.dart';

class ChatService {
  final List<ChatConversation> _conversations = [];
  final Random _random = Random();

  // Messages prédéfinis pour simuler des réponses automatiques
  final List<String> _clientResponses = [
    "Bonjour ! Je suis intéressé par vos produits bio.",
    "Pouvez-vous me donner plus de détails sur vos méthodes de culture ?",
    "Quels sont vos prix pour les tomates ?",
    "Avez-vous d'autres légumes disponibles ?",
    "C'est parfait ! Quand pouvez-vous livrer ?",
    "Merci pour ces informations. Je vais réfléchir.",
    "Vos produits ont l'air de très bonne qualité !",
    "Pouvez-vous me dire si vous faites de la livraison ?",
    "J'aimerais commander pour la semaine prochaine.",
    "Vos prix sont très compétitifs !",
  ];

  final List<String> _producerResponses = [
    "Bonjour ! Je serais ravi de vous fournir mes produits.",
    "Je cultive en agriculture biologique depuis 5 ans.",
    "Mes tomates sont à 3€/kg, fraîchement cueillies.",
    "J'ai aussi des courgettes, aubergines et poivrons.",
    "Je peux livrer dans un rayon de 10km.",
    "Mes produits sont garantis sans pesticides.",
    "Je récolte tous les matins pour une fraîcheur optimale.",
    "Je peux vous proposer un panier personnalisé.",
    "Parfait ! Je vous prépare votre commande.",
    "N'hésitez pas si vous avez d'autres questions !",
  ];

  // Créer une nouvelle conversation
  ChatConversation createConversation(ChatClient client) {
    final conversationId = 'conv_${DateTime.now().millisecondsSinceEpoch}';
    
    // Message de bienvenue automatique
    final welcomeMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: client.id,
      content: "Bonjour ! Je suis intéressé par vos produits bio. Pouvez-vous me donner plus d'informations ?",
      timestamp: DateTime.now(),
      isFromProducer: false,
    );

    final conversation = ChatConversation(
      id: conversationId,
      client: client,
      messages: [welcomeMessage],
      lastActivity: DateTime.now(),
    );

    _conversations.add(conversation);
    return conversation;
  }

  // Envoyer un message
  Future<void> sendMessage(String conversationId, String content) async {
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex == -1) return;

    final conversation = _conversations[conversationIndex];
    
    // Ajouter le message du producteur
    final producerMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'producer',
      content: content,
      timestamp: DateTime.now(),
      isFromProducer: true,
    );

    final updatedMessages = [...conversation.messages, producerMessage];
    
    _conversations[conversationIndex] = conversation.copyWith(
      messages: updatedMessages,
      lastActivity: DateTime.now(),
    );

    // Simuler une réponse automatique du client après 2-4 secondes
    await Future.delayed(Duration(seconds: 2 + _random.nextInt(3)));
    
    if (_conversations[conversationIndex].isActive) {
      final clientResponse = _clientResponses[_random.nextInt(_clientResponses.length)];
      
      final clientMessage = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: conversation.client.id,
        content: clientResponse,
        timestamp: DateTime.now(),
        isFromProducer: false,
      );

      final finalMessages = [...updatedMessages, clientMessage];
      
      _conversations[conversationIndex] = _conversations[conversationIndex].copyWith(
        messages: finalMessages,
        lastActivity: DateTime.now(),
      );
    }
  }

  // Envoyer une réponse automatique du producteur
  Future<void> sendAutoResponse(String conversationId) async {
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex == -1) return;

    final conversation = _conversations[conversationIndex];
    final autoResponse = _producerResponses[_random.nextInt(_producerResponses.length)];
    
    await sendMessage(conversationId, autoResponse);
  }

  // Obtenir une conversation
  ChatConversation? getConversation(String conversationId) {
    try {
      return _conversations.firstWhere((c) => c.id == conversationId);
    } catch (e) {
      return null;
    }
  }

  // Obtenir toutes les conversations
  List<ChatConversation> getAllConversations() {
    return List.unmodifiable(_conversations);
  }

  // Fermer une conversation
  void closeConversation(String conversationId) {
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      _conversations[conversationIndex] = _conversations[conversationIndex].copyWith(
        isActive: false,
      );
    }
  }

  // Supprimer une conversation
  void deleteConversation(String conversationId) {
    _conversations.removeWhere((c) => c.id == conversationId);
  }
}

// Provider pour le service de chat
final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});