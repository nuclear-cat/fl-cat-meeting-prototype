import 'package:flutter/widgets.dart';
import 'package:login_test/exceptions/unauthorized_exception.dart';
import 'package:login_test/services/api_service.dart';
import 'meeting_provider.dart';

class MeetingDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  MeetingDetailProvider({required this.apiService});

  MeetingProvider? item;
  bool itemIsLoading = false;
  String? error;

  void fetchMeetingDetail(String id, BuildContext context) async {
    itemIsLoading = true;

    await Future.delayed(const Duration(seconds: 0));

    try {
      final responseData = await apiService.get('/api/meeting/${id}', context);

      itemIsLoading = false;

      item = MeetingProvider(
        id: responseData['id'],
        title: responseData['title'],
        description: responseData['description'],
        minParticipantsNumber: responseData['min_participants_number'],
        totalParticipations: responseData['total_participations'],
        imageUrl: '',
        isJoined: responseData['user_participations'] > 0,
      );
    } on UnauthorizedException catch (_) {
      await Navigator.of(context)
          .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
    } on Exception catch (exception) {
      itemIsLoading = false;
      error = exception.toString();
    }

    notifyListeners();
  }
}
