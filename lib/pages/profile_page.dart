import 'package:flutter/material.dart';
import 'package:musicorum/api/models/user.dart';
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
  double scrollOffset = 0.0;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    if (controller != null) {
      controller.addListener(() {
        if (!controller.hasClients) return;
        setState(() {
          scrollOffset = controller.offset;
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBarVisibility = ContentHeader.getHeaderFractionFromOffset(context, scrollOffset);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        title: Opacity(
          opacity: appBarVisibility,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(backgroundImage: widget.user.images.getMediumImage().image, radius: 16,),
              SizedBox(width: 10.0,),
              Text(widget.user.displayName,)
            ],
          ),
        ),
        backgroundColor:
        APPBAR_COLOR.withAlpha((appBarVisibility * 255).toInt()),
      ),
      body: Consumer<LoginState>(
        builder: (context, loginState, child) {
          print(loginState.user);
          return Profile(widget.user, controller: controller, loggedInUser: loginState.user,);
        },
      ),
    );
  }
}
