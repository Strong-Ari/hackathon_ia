import 'dart:async';
import 'dart:math';
import '../models/client_model.dart';

class ClientService {
  static final ClientService _instance = ClientService._internal();
  factory ClientService() => _instance;
  ClientService._internal();

  // Données mockées pour les clients
  final List<Client> _mockClients = [
    Client(
      id: '1',
      name: 'Marie Dubois',
      photoPath: null,
      interest: 'Cherche tomates bio',
      location: 'Lyon, 5km',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Client(
      id: '2',
      name: 'Pierre Martin',
      photoPath: null,
      interest: 'Intéressé par vos carottes',
      location: 'Grenoble, 8km',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Client(
      id: '3',
      name: 'Sophie Bernard',
      photoPath: null,
      interest: 'Recherche pommes de terre',
      location: 'Chambéry, 12km',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Client(
      id: '4',
      name: 'Lucas Moreau',
      photoPath: null,
      interest: 'Cherche salades fraîches',
      location: 'Annecy, 15km',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Client(
      id: '5',
      name: 'Emma Roux',
      photoPath: null,
      interest: 'Intéressée par vos herbes aromatiques',
      location: 'Aix-les-Bains, 10km',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  // Conversations actives
  final Map<String, ChatConversation> _conversations = {};

  // Messages mockés pour chaque client
  final Map<String, List<Message>> _mockMessages = {
    '1': [
      Message(
        id: '1_1',
        clientId: '1',
        content: 'Bonjour ! Je suis intéressée par vos tomates bio. Avez-vous des tomates cerises disponibles ?',
        isFromProducer: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Message(
        id: '1_2',
        clientId: '1',
        content: 'Oui, j\'ai des tomates cerises et des tomates cœur de bœuf. Quand souhaitez-vous les récupérer ?',
        isFromProducer: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      Message(
        id: '1_3',
        clientId: '1',
        content: 'Parfait ! Je peux passer demain après-midi. Quel est le prix au kilo ?',
        isFromProducer: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
    ],
    '2': [
      Message(
        id: '2_1',
        clientId: '2',
        content: 'Salut ! J\'ai vu vos carottes sur l\'app. Elles ont l\'air superbes !',
        isFromProducer: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      Message(
        id: '2_2',
        clientId: '2',
        content: 'Merci ! Elles sont cultivées sans pesticides. Combien en voulez-vous ?',
        isFromProducer: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
    ],
    '3': [
      Message(
        id: '3_1',
        clientId: '3',
        content: 'Bonjour, je recherche des pommes de terre pour ma famille. Avez-vous des variétés différentes ?',
        isFromProducer: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ],
    '4': [
      Message(
        id: '4_1',
        clientId: '4',
        content: 'Coucou ! Vos salades ont l\'air délicieuses. Cultivez-vous aussi des endives ?',
        isFromProducer: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ],
    '5': [
      Message(
        id: '5_1',
        clientId: '5',
        content: 'Bonjour ! J\'adore cuisiner et j\'aimerais acheter vos herbes aromatiques. Quelles variétés proposez-vous ?',
        isFromProducer: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ],
  };

  // Simuler la recherche de clients
  Future<List<Client>> searchNearbyClients() async {
    // Simuler un délai de recherche
    await Future.delayed(const Duration(seconds: 2));
    
    // Retourner 1-3 clients aléatoires
    final random = Random();
    final count = random.nextInt(3) + 1;
    final shuffled = List<Client>.from(_mockClients)..shuffle(random);
    
    return shuffled.take(count).toList();
  }

  // Créer une conversation avec un client
  ChatConversation createConversation(Client client) {
    final conversationId = 'conv_${client.id}';
    
    if (_conversations.containsKey(conversationId)) {
      return _conversations[conversationId]!;
    }

    final messages = _mockMessages[client.id] ?? [];
    final conversation = ChatConversation(
      id: conversationId,
      client: client,
      messages: messages,
      lastActivity: DateTime.now(),
    );

    _conversations[conversationId] = conversation;
    return conversation;
  }

  // Envoyer un message
  Future<Message> sendMessage(String conversationId, String content) async {
    final conversation = _conversations[conversationId];
    if (conversation == null) {
      throw Exception('Conversation non trouvée');
    }

    // Créer le nouveau message
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      clientId: conversation.client.id,
      content: content,
      isFromProducer: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Simuler l'envoi
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mettre à jour le statut
    final sentMessage = message.copyWith(status: MessageStatus.sent);
    
    // Ajouter le message à la conversation
    final updatedMessages = [...conversation.messages, sentMessage];
    final updatedConversation = conversation.copyWith(
      messages: updatedMessages,
      lastActivity: DateTime.now(),
    );
    
    _conversations[conversationId] = updatedConversation;

    // Simuler une réponse automatique du client après 2-5 secondes
    _simulateClientResponse(conversation.client, conversationId);

    return sentMessage;
  }

  // Simuler une réponse automatique du client
  void _simulateClientResponse(Client client, String conversationId) {
    final responses = [
      'Merci pour votre réponse !',
      'Parfait, je note !',
      'Super, à bientôt !',
      'D\'accord, je vous recontacte !',
      'Merci beaucoup !',
      'C\'est noté, merci !',
      'Parfait, je passe demain !',
      'Excellent, je vous confirme !',
    ];

    final random = Random();
    final delay = Duration(seconds: random.nextInt(3) + 2);
    
    Timer(delay, () {
      final response = responses[random.nextInt(responses.length)];
      final message = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        clientId: client.id,
        content: response,
        isFromProducer: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );

      final conversation = _conversations[conversationId];
      if (conversation != null) {
        final updatedMessages = [...conversation.messages, message];
        final updatedConversation = conversation.copyWith(
          messages: updatedMessages,
          lastActivity: DateTime.now(),
        );
        
        _conversations[conversationId] = updatedConversation;
      }
    });
  }

  // Obtenir une conversation
  ChatConversation? getConversation(String conversationId) {
    return _conversations[conversationId];
  }

  // Obtenir toutes les conversations
  List<ChatConversation> getAllConversations() {
    return _conversations.values.toList()
      ..sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
  }

  // Supprimer une conversation
  void deleteConversation(String conversationId) {
    _conversations.remove(conversationId);
  }
}