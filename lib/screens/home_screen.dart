import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_test/providers/meeting_provider.dart';
import 'package:login_test/providers/meetings_provider.dart';
import 'package:login_test/widgets/meeting_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final MeetingsProvider _meetingsProvider =
        Provider.of<MeetingsProvider>(context, listen: false);
    _meetingsProvider.fetchMeetings(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MeetingsProvider _meetingsProvider =
        Provider.of<MeetingsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Consumer<MeetingsProvider>(
          builder: (context, MeetingsProvider meetingsData, _) {
        if (meetingsData.itemsIsLoading && meetingsData.currentPage == 1) {
          return const Center(child: CircularProgressIndicator());
        }

        if (meetingsData.error != null) {
          return Center(child: Text(meetingsData.error!));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await _meetingsProvider.refreshMeetings(context);
          },
          child: ListView.separated(
            itemCount: meetingsData.items.length + 1,
            itemBuilder: (BuildContext context, int index) {
              _meetingsProvider.paginate(index, context);

              if (index == meetingsData.items.length) {
                return meetingsData.itemsIsLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(),
                            height: 20.0,
                            width: 20.0,
                          ),
                        ),
                      )
                    : const SizedBox(width: 0, height: 0);
              }

              final MeetingProvider meeting = meetingsData.items[index];

              return ChangeNotifierProvider.value(
                value: meeting,
                child: const MeetingItem(),
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
          ),
        );
      }),
    );
  }
}
