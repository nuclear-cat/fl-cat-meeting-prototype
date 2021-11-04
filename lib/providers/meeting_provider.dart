import 'package:flutter/foundation.dart';

class MeetingProvider with ChangeNotifier {
  final String? id;
  String title;
  String? description;
  int minParticipantsNumber;
  String imageUrl;
  int totalParticipations;
  bool isJoined;

  MeetingProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.minParticipantsNumber,
    required this.imageUrl,
    required this.totalParticipations,
    required this.isJoined,
  });

  void setJoin() {
    isJoined = !isJoined;
    notifyListeners();
  }
}
