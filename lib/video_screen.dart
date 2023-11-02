import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rowan_video_player/dialog.dart';
import 'package:rowan_video_player/provider/video_button_text_provider.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    videoPlayerController =
        VideoPlayerController.asset('assets/videos/video_1.mp4')
          ..initialize().then((value) {
            setState(() {});
          });
    _customVideoPlayerController = CustomVideoPlayerController(
      videoPlayerController: videoPlayerController,
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
        showFullscreenButton: false,
        placeholderWidget: Center(
          child: CircularProgressIndicator(),
        ),
        settingsButtonAvailable: false,
      ),
      context: context,
    );
    super.initState();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Image.asset('assets/images/rowan_logo.png'),
        ),
        title: const Text(
          '도움영상',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await showExitDialog(context: context);
              },
              icon:
                  const Icon(Icons.exit_to_app_rounded, color: Colors.black87))
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                videoPlayerController.value.isInitialized
                    ? SizedBox(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CustomVideoPlayer(
                            customVideoPlayerController:
                                _customVideoPlayerController,
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (videoPlayerController.value.isPlaying) {
                          videoPlayerController.pause();
                          ref
                              .read(videoButtonTextStateProvider.notifier)
                              .update((state) =>
                                  videoPlayerController.value.isPlaying);
                        } else {
                          videoPlayerController.play();
                          ref
                              .read(videoButtonTextStateProvider.notifier)
                              .update((state) =>
                                  videoPlayerController.value.isPlaying);
                        }
                      },
                      child: Text(
                        ref.watch(videoButtonTextStateProvider) ? '일시정지' : '재생',
                      ),
                    ),
                    const SizedBox(width: 20),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (videoPlayerController.value.isPlaying) {
                    //       videoPlayerController.pause();
                    //       ref
                    //           .read(videoButtonTextStateProvider.notifier)
                    //           .update((state) =>
                    //               videoPlayerController.value.isPlaying);
                    //     } else {
                    //       videoPlayerController.play();
                    //       ref
                    //           .read(videoButtonTextStateProvider.notifier)
                    //           .update((state) =>
                    //               videoPlayerController.value.isPlaying);
                    //     }
                    //   },
                    //   child: Text(
                    //     ref.watch(videoButtonTextStateProvider) ? '일시정지' : '재생',
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
