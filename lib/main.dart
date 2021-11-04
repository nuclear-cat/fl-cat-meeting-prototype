import 'package:flutter/material.dart';
import 'package:login_test/providers/login_provider.dart';
import 'package:login_test/providers/meeting_detail_provider.dart';
import 'package:login_test/providers/meetings_provider.dart';
import 'package:login_test/screens/auth_screen.dart';
import 'package:login_test/screens/home_screen.dart';
import 'package:login_test/screens/login_screen.dart';
import 'package:login_test/screens/meeting_detail_screen.dart';
import 'package:login_test/services/api_service.dart';
import 'package:login_test/services/auth_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String? accessToken = await AuthService().getAccessToken();
  final bool isAuth = accessToken != null;

  runApp(App(isAuth: isAuth));
}

class App extends StatelessWidget {
  final bool isAuth;

  const App({Key? key, required this.isAuth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MeetingsProvider(apiService: apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => MeetingDetailProvider(apiService: apiService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/auth': (context) => const AuthScreen(),
          'login': (context) => const LoginScreen(),
          '/meeting_detail': (context) => const MeetingDetailScreen(),
        },
        initialRoute: isAuth ? '/home' : '/auth',
      ),
    );
  }
}
