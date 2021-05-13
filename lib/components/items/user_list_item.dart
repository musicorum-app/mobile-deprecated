import 'package:flutter/material.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:musicorum/constants/common.dart';
import 'package:musicorum/pages/profile.dart';
import 'package:musicorum/pages/profile_page.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(CONTENT_LIST_BOX_BORDER)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(user),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: CONTENT_LIST_MARGIN_V),
        padding: EdgeInsets.symmetric(
            horizontal: CONTENT_LIST_PADDING_H,
            vertical: CONTENT_LIST_PADDING_V),
        child: Row(
          children: [
            CircleAvatar(
              radius: CONTENT_LIST_IMAGE_WIDTH / 2,
              backgroundImage: user.images.getMediumImage().image,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: Text(
              user.displayName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ))
          ],
        ),
      ),
    );
  }
}
