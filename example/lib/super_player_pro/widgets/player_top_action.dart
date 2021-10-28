import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'mark.dart';

class PlayerTopAction extends StatelessWidget {
  const PlayerTopAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const MarkListButton(),
        CupertinoButton(
          child: Image.asset(
            'assets/images/ic_player_download.png',
            width: 20,
          ),
          onPressed: () {},
        ),
        CupertinoButton(
          child: Image.asset(
            'assets/images/ic_player_collect_nor.png',
            width: 20,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
