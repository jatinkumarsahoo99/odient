import 'package:dtcameo/main.dart';
import 'package:dtcameo/provider/videoviewprovider.dart';
import 'package:dtcameo/utils/color.dart';
import 'package:dtcameo/utils/dimens.dart';
import 'package:dtcameo/utils/utils.dart';
import 'package:dtcameo/widget/mynetworkimmage.dart';
import 'package:dtcameo/widget/mytext.dart';
import 'package:dtcameo/widget/videoplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoScreen extends StatefulWidget {
  final int pagePos;
  final String videoUrl, videoId, thumbnailImg;
  const VideoScreen({
    super.key,
    required this.pagePos,
    required this.videoUrl,
    required this.videoId,
    required this.thumbnailImg,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with RouteAware {
  VideoPlayerController? videoController;
  late VideoViewProvider videoScreenProvider;
  late Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    videoScreenProvider =
        Provider.of<VideoViewProvider>(context, listen: false);
    videoScreenProvider.addShortView(widget.videoId);
    super.initState();
  }

  checkAdAndInitialize() {
    initController(startPlaying: true);
  }

  Future<void> initController({required bool startPlaying}) async {
    printLog("current videoUrl =======> ${widget.videoUrl}");
    printLog("current pagePos ===> ${widget.pagePos}");
    try {
      if (videoController == null) {
        videoController =
            VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        _initializeVideoPlayerFuture =
            videoController?.initialize().then((value) {
          if (!mounted) return;
          setState(() {});
          if (startPlaying) {
            playVideo();
          }
        });
      }
    } catch (e) {
      printLog("setVideoController Exception =========> $e");
    }
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void didPop() {
    printLog("========= didPop =========");
    super.didPop();
  }

  @override
  void didPopNext() {
    printLog("========= didPopNext =========");
    super.didPopNext();
  }

  @override
  void didPush() {
    printLog(
        "visibleInfo =====didPush====> ${videoScreenProvider.visibleInfo?.visibleFraction}");
    if (videoScreenProvider.visibleInfo?.visibleFraction == 0.0) {
      clearController();
    }
    printLog("========= didPush =========");
    super.didPush();
  }

  @override
  void didPushNext() {
    printLog(
        "visibleInfo =====didPushNext====> ${videoScreenProvider.visibleInfo?.visibleFraction}");
    if (videoScreenProvider.visibleInfo?.visibleFraction == 0.0) {
      clearController();
    }
    printLog("========= didPushNext =========");
    super.didPushNext();
  }

  @override
  void dispose() {
    videoScreenProvider.clearProvider();
    routeObserver.unsubscribe(this);
    clearController();
    printLog("========= dispose =========");
    super.dispose();
  }

  playVideo() async {
    if (videoController != null) {
      await videoController?.play();
      await videoController?.setLooping(true);
      if (!mounted) return;
      setState(() {});
    }
  }

  pauseVideo() async {
    if (videoController != null) {
      await videoController?.pause();
      if (!mounted) return;
      setState(() {});
    }
  }

  clearController() async {
    videoController?.dispose();
    videoController = null;
  }

  @override
  Widget build(BuildContext context) {
    printLog("Enter Video Build");
    return VisibilityDetector(
      key: Key('reel_${widget.pagePos}'),
      onVisibilityChanged: (visibilityInfo) async {
        if (!mounted) return;
        final videoScreenProvider =
            Provider.of<VideoViewProvider>(context, listen: false);
        videoScreenProvider.setVisibilityInfo(visibilityInfo);
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        printLog(
            '=========== Widget ${visibilityInfo.key} is $visiblePercentage% visible===========');
        if (visiblePercentage > 80.0) {
          checkAdAndInitialize();
        } else {
          pauseVideo();
          clearController();
        }
      },
      child: _buildFuture(),
    );
  }

  Widget _buildFuture() {
    return _buildPlayer();
  }

  Widget _buildPlayer() {
    if (videoController == null) {
      return _buildImage();
    } else {
      return GestureDetector(
        onTap: () {
          printLog("click");
          if (!(videoController?.value.isPlaying ?? false)) {
            playVideo();
          } else {
            pauseVideo();
          }
        },
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ValueListenableBuilder(
                  valueListenable: videoController!,
                  builder: (context, VideoPlayerValue value, child) {
                    final position = value.position;
                    final duration = value.duration;

                    final progress = duration.inSeconds > 0
                        ? position.inSeconds / duration.inSeconds
                        : 0.0;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: SizedBox(
                              width: videoController?.value.size.width,
                              height: videoController?.value.size.height,
                              child: AspectRatio(
                                aspectRatio:
                                    videoController?.value.aspectRatio ??
                                        16 / 9,
                                child: VideoPlayer(videoController!),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: VideoPlayPause(controller: videoController!),
                        ),
                        Positioned(
                          bottom: 10, // Position the progress bar at the bottom
                          left: 15,
                          right: 15,
                          child: Row(
                            children: [
                              MyText(
                                color: white,
                                text: _formatDuration(position),
                                fontsize: Dimens.textSmall,
                                fontwaight: FontWeight.w600,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.red),
                                ),
                              ),
                              const SizedBox(width: 10),
                              MyText(
                                color: white,
                                text: _formatDuration(duration),
                                fontsize: Dimens.textSmall,
                                fontwaight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              return _buildLoadingWithImage();
            }
          },
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildImage() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          MyNetworkImage(
            imgHeight: MediaQuery.of(context).size.height,
            imgWidth: MediaQuery.of(context).size.width,
            imageUrl: widget.thumbnailImg,
            fit: BoxFit.fill,
          ),

          /* Play Button */
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 60,
              width: 60,
              decoration: Utils.setGradTTBBGWithBorder(
                  colorPrimaryDark.withOpacity(0.45),
                  white.withOpacity(0.45),
                  transparent,
                  40,
                  0),
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: colorAccent),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 20,
                    color: colorPrimaryDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWithImage() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          MyNetworkImage(
            imgHeight: MediaQuery.of(context).size.height,
            imgWidth: MediaQuery.of(context).size.width,
            imageUrl: widget.thumbnailImg,
            fit: BoxFit.fill,
          ),

          /* Play Button */
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 60,
              width: 60,
              child: Utils.pageLoader(),
            ),
          ),
        ],
      ),
    );
  }
}
