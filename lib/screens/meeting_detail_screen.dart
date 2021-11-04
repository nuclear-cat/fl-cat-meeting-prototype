import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_test/providers/meeting_detail_provider.dart';
import 'package:provider/provider.dart';

class MeetingDetailScreen extends StatefulWidget {
  const MeetingDetailScreen({Key? key}) : super(key: key);

  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final meetingId = ModalRoute.of(context)!.settings.arguments as String;

    final MeetingDetailProvider _meetingProvider =
        Provider.of<MeetingDetailProvider>(context, listen: false);

    _meetingProvider.fetchMeetingDetail(meetingId, context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting'),
      ),
      body: Consumer<MeetingDetailProvider>(
          builder: (context, MeetingDetailProvider meetingData, _) {
        if (meetingData.itemIsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (meetingData.error != null) {
          return Center(child: Text(meetingData.error!));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    meetingData.item!.title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Минимум: ' +
                        meetingData.item!.minParticipantsNumber.toString(),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(meetingData.item!.description ?? ''),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
