import 'package:flutter/widgets.dart';
import 'package:login_test/exceptions/unauthorized_exception.dart';
import 'package:login_test/services/api_service.dart';
import 'meeting_provider.dart';

class MeetingsProvider extends ChangeNotifier {
  final ApiService apiService;

  MeetingsProvider({required this.apiService});

  List<MeetingProvider> items = [];
  bool itemsIsLoading = false;
  String? error;
  int currentPage = 1;
  int _totalPages = 1;

  Future<void> refreshMeetings(BuildContext context) async {
    currentPage = 1;
    _totalPages = 1;
    items = [];

    await fetchMeetings(context);
  }

  Future<void> fetchMeetings(BuildContext context) async {
    itemsIsLoading = true;

    await Future.delayed(const Duration(seconds: 0));

    notifyListeners();

    try {
      final responseData =
          await apiService.get('/api/meeting/list?page=$currentPage', context);

      List meetingItems = responseData['items'] as List;
      _totalPages = responseData['total_pages'] as int;

      List<MeetingProvider> meetings = meetingItems
          .map(
            (item) => MeetingProvider(
              id: item['id'],
              title: item['title'],
              description: item['description'],
              minParticipantsNumber: item['min_participants_number'],
              totalParticipations: item['total_participations'],
              imageUrl: '',
              isJoined: item['user_participations'] > 0,
            ),
          )
          .toList();

      items.addAll(meetings);
    } on UnauthorizedException catch (_) {
      await Navigator.of(context)
          .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
    } on Exception catch (exception) {
      error = exception.toString();
    }

    itemsIsLoading = false;
    notifyListeners();
  }

  paginate(int index, BuildContext context) {
    if (currentPage >= _totalPages) {
      return;
    }

    if (itemsIsLoading) {
      return;
    }

    if (index >= items.length - 1) {
      currentPage++;
      fetchMeetings(context);
    }
  }

  Future<void> joinMeeting({
    required BuildContext context,
    required String meetingId,
    required int expectsTotalParticipations,
  }) async {
    final responseData =
        await apiService.post('/api/meeting/$meetingId/join', context, {
      'expects_total_participations': expectsTotalParticipations,
    });

    print(responseData);

    notifyListeners();
  }
}
