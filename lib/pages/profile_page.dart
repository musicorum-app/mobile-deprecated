import 'package:flutter/material.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/components/animated_appbar.dart';
import 'package:musicorum/components/content_header.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/pages/profile.dart';
import 'package:musicorum/states/login.dart';
import 'package:musicorum/utils/common.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(this.user);

  final User user;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  ScrollController controller = ScrollController();
  final _scrollOffsetNotifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    if (controller != null) {
      controller.addListener(() {
        if (!controller.hasClients) return;
        _scrollOffsetNotifier.value = controller.offset;
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AnimatedAppBar(
        name: widget.user.displayName,
        image:  widget.user.images.getMediumImage().image,
        notifier: _scrollOffsetNotifier,
        radius: 16,
      ),
      body: Consumer<AuthState>(
        builder: (context, loginState, child) {
          print(loginState.user);
          return Profile(widget.user, controller: controller, loggedInUser: loginState.user,);
        },
      ),
    );
  }
}
