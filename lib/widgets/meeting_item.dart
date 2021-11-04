import 'package:flutter/material.dart';
import 'package:login_test/providers/meeting_provider.dart';
import 'package:login_test/widgets/join_bottom_sheet.dart';
import 'package:provider/provider.dart';

class MeetingItem extends StatelessWidget {
  const MeetingItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MeetingProvider meeting =
        Provider.of<MeetingProvider>(context, listen: false);

    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                meeting.title,
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
                'Минимум: ' + meeting.minParticipantsNumber.toString(),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Участвует: ' + meeting.totalParticipations.toString(),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                meeting.description ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                    ),
                    builder: (BuildContext context) {
                      return ChangeNotifierProvider.value(
                        value: meeting,
                        child: const JoinBottomSheet(),
                      );
                    },
                  );
                },
                child: Text('Участвовать'),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/meeting_detail',
          arguments: meeting.id,
        );
      },
    );
  }
}
