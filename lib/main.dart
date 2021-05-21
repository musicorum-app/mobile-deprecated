import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/api/musicorum.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musicorum/constants/storage_keys.dart';
import 'package:musicorum/pages/logged_in_router.dart';
import 'package:musicorum/pages/login.dart';
import 'package:musicorum/states/login.dart';
import 'package:provider/provider.dart';

void main() {
  setAppDefaultColors();

  runApp(MyApp());
}

void setAppDefaultColors() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: SURFACE_SECONDARY_COLOR, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: APPBAR_COLOR
          ),
          brightness: Brightness.dark,
          fontFamily: 'Poppins',
          primaryColor: MUSICORUM_COLOR,
          accentColor: MUSICORUM_COLOR,
          scaffoldBackgroundColor: SURFACE_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AccountHandler(),
      ),
    );
  }
}

class AccountHandler extends StatefulWidget {
  AccountHandler({Key key}) : super(key: key);

  @override
  _AccountHandlerState createState() => _AccountHandlerState();
}

class _AccountHandlerState extends State<AccountHandler> {
  bool loggedIn = false;

  @override
  void initState() {
    this.handleLogin(context);

    super.initState();
  }

  void handleLogin(BuildContext context) async {
    final storage = new FlutterSecureStorage();
    loggedIn = await storage.containsKey(key: STORAGE_TOKEN_KEY);
    final token = await storage.read(key: STORAGE_TOKEN_KEY);
    final loginState = Provider.of<AuthState>(context, listen: false);
    loginState.rootNavigator = Navigator.of(context);

    if (loggedIn) {
      loginState.login(token);

      User usr = await MusicorumApi.getAccountFromToken(token);

      loginState.setUser(usr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, loginState, child) {
        return loginState.isLoggedIn ? LoggedInRouter() : LoginPage();
      },
    );
  }
}
