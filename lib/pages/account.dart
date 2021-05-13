import 'package:flutter/material.dart';
import 'package:musicorum/pages/profile.dart';
import 'package:musicorum/states/login.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AccountPageState();
  }
}

class AccountPageState extends State<AccountPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginState>(
        builder: (context, loginState, child) {
          print(loginState.user);
          return loginState.isUserLoaded ? Profile(loginState.user, loggedInUser: loginState.user,) : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
