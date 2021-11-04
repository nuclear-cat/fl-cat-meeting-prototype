import 'package:flutter/material.dart';
import 'package:login_test/providers/meeting_detail_provider.dart';
import 'package:login_test/providers/meeting_provider.dart';
import 'package:login_test/providers/meetings_provider.dart';
import 'package:provider/provider.dart';

class JoinBottomSheet extends StatelessWidget {
  const JoinBottomSheet({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _participantsNumber = TextEditingController();
    _participantsNumber.text = '100';

    // final Participations participations =
    // Provider.of<Participations>(context, listen: false);

    final MeetingProvider _meeting =
        Provider.of<MeetingProvider>(context, listen: false);

    final MeetingsProvider _meetingsProvider =
        Provider.of<MeetingsProvider>(context, listen: false);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Пойду, если наберется:',
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextField(
              controller: _participantsNumber,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: "Количество участников",
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal))),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            const SizedBox(
                width: double.infinity,
                child: Text(
                  'участников',
                  textAlign: TextAlign.center,
                )),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                child: const Text('Участвовать'),
                onPressed: () async {

                  _meetingsProvider.joinMeeting(
                    meetingId: _meeting.id!,
                    context: context,
                    expectsTotalParticipations:
                        int.parse(_participantsNumber.text),
                  );

                  // participations.addItem(
                  //   _meeting.id!,
                  //   _meeting.title,
                  //   int.parse(_participantsNumber.text),
                  // );
                  // Navigator.pop(context);
                  //
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text('Вы участвуете в «${_meeting.title}»'),
                  //   duration: const Duration(seconds: 2),
                  //   action: SnackBarAction(
                  //     label: 'Отменить',
                  //     onPressed: () {
                  //       participations.removeItem(_meeting.id!);
                  //     },
                  //   ),
                  // ));
                  //
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
