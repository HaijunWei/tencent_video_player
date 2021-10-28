import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_video_player/video_player.dart';
import 'super_player/super_player.dart';
import 'super_player_pro/super_player_pro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              child: const Text('视频'),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => const VideoPage()),
                );
              },
            ),
            CupertinoButton(
              child: const Text('直播'),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => const LivePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late SuperPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SuperPlayerController(
      title: '点播测试 - flv',
      playerController: HJVideoPlayerController(PlayerType.vod),
    );

    _controller.play(
      VideoDataSource(
        url:
            'https://sf1-hscdn-tos.pstatp.com/obj/media-fe/xgplayer_doc_video/flv/xgplayer-demo-720p.flv',
      ),
      autoPlay: false,
      position: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SuperPlayerPro(
            controller: _controller,
          ),
        ],
      ),
    );
  }
}

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  late SuperPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SuperPlayerController(
      title: '直播测试 - flv',
      playerController: HJVideoPlayerController(PlayerType.live),
    );
    _controller.play(
      VideoDataSource(
        url:
            'http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid_demo1080p.flv',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SuperPlayerPro(
            controller: _controller,
          ),
        ],
      ),
    );
  }
}
