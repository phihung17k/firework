import 'package:flutter/material.dart';

class TestAudioWidget extends StatefulWidget {
  const TestAudioWidget({super.key});

  @override
  State<TestAudioWidget> createState() => _TestAudioWidgetState();
}

class _TestAudioWidgetState extends State<TestAudioWidget> {
  // late VideoPlayerController _controller;
  // ChewieAudioController? _audioController;

  // final webview = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..loadRequest(Uri.parse(
  //       'https://codeskulptor-demos.commondatastorage.googleapis.com/descent/gotitem.mp3'));
  // late html.IFrameElement _iframeElement;
  // bool isIframeReady = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    // _iframeElement = html.IFrameElement()
    //   ..width = '300'
    //   ..height = '150'
    //   ..src =
    //       '<iframe src="https://codeskulptor-demos.commondatastorage.googleapis.com/descent/gotitem.mp3" allow="autoplay">'
    //   ..style.border = 'none';
  }

  void _init() async {
    // if (!_controller.value.isInitialized) {}
    // await _controller.initialize();
    // _audioController = ChewieAudioController(
    //   videoPlayerController: _controller,
    //   // autoInitialize: true,
    //   autoPlay: true,
    // );
    // setState(() {});
    // await _controller.play();
  }

  @override
  void dispose() {
    // _player.dispose();
    // _controller.dispose();
    // _audioController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("AAAAAAAAAAAAAAAAAAAA"),
      ),
      body: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Expanded(child: VideoPlayer(_controller)),
              // Flexible(
              //   // child: ChewieAudio(
              //   //   controller: _audioController!,
              //   // ),
              //   // child: HtmlElementView(viewType: "test_html"),
              //   // child: WebViewWidget(controller: webview),
              //   child: HtmlWidget(
              //     "<iframe class='audio' src='https://codeskulptor-demos.commondatastorage.googleapis.com/descent/gotitem.mp3'>",
              //     customStylesBuilder: (element) {
              //       if (element.localName == "iframe") {
              //         debugPrint("localName ------------------");
              //         return {
              //           'width': '100%',
              //           'height': '100%',
              //           'allow': 'autoplay'
              //         };
              //       }
              //     },
              //   ),
              // ),

              ElevatedButton(
                onPressed: () {
                  // _player.play();
                },
                child: const Text('Play'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
