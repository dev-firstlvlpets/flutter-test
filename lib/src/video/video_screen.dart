import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  static const routeName = '/video';

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    //TODO: call async function in initState:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _test();
    });

    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://aakktibsfgbbisvdzrki.supabase.co/storage/v1/object/public/PetVideos/public/854132-hd_1280_720_50fps.mp4'))
      //'https://aakktibsfgbbisvdzrki.supabase.co/storage/v1/object/sign/PetVideos/public/854132-hd_1280_720_50fps.mp4?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJQZXRWaWRlb3MvcHVibGljLzg1NDEzMi1oZF8xMjgwXzcyMF81MGZwcy5tcDQiLCJpYXQiOjE3MTI2NDk0NTAsImV4cCI6MTcxMjY1MzA1MH0.1iLBigqRI8Q0JDv1Uh3T2a9JnT8TEuXXKoTx0WGaa_o'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: 16.0 / 9.0, //_controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(
                child: const CircularProgressIndicator(),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _test() async {
    // final supabase = Supabase.instance.client;
    // final signedUrl = await supabase.storage
    //     .from('PetVideos')
    //     .createSignedUrl('public/854132-hd_1280_720_50fps.mp4', 3600);

    //print(signedUrl);
  }
}
