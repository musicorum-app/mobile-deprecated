import 'package:flutter/material.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/api/musicorum.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:musicorum/constants/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musicorum/constants/storage_keys.dart';
import 'package:musicorum/states/login.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  void login() async {
    final result = await FlutterWebAuth.authenticate(
      url: MUSICORUM_LOGIN_URL,
      callbackUrlScheme: MUSICORUM_URL_SCHEME
    );

    final token = Uri.parse(result).queryParameters['token'];
    final storage = new FlutterSecureStorage();
    await storage.write(key: STORAGE_TOKEN_KEY, value: token);

    print('SETTING LOGIN');
    final loginState = Provider.of<LoginState>(context, listen: false);

    User usr = await MusicorumApi.getAccountFromToken(token);

    loginState.setUser(usr);
    loginState.login(await storage.read(key: STORAGE_TOKEN_KEY));

    print(Uri.parse(result).queryParameters['user']);

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please login with Last.fm'),
            MaterialButton(
              onPressed: login,
              color: MUSICORUM_COLOR,
              child: Text('Login with Last.fm', style: TextStyle(fontSize: 18),),
            )
          ],
        ),
      ),
    );
  }
}
