// ignore_for_file: unnecessary_null_comparison, must_be_immutable, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class GstPlayerTextureController {
  static const MethodChannel _channel =
      MethodChannel('flutter_gstreamer_player');

  var currentPlatform = Platform.operatingSystem;
  int textureId = 0;
  static int _id = 0;

  Future<int> initialize(String pipeline) async {
    // No idea why, but you have to increase `_id` first before pass it to method channel,
    // if not, receiver of method channel always received 0
    if (currentPlatform == "ios") {
      GstPlayerTextureController._id = GstPlayerTextureController._id + 1;
    }
    textureId = await _channel.invokeMethod('PlayerRegisterTexture', {
      'pipeline': pipeline,
      'playerId': GstPlayerTextureController._id,
    });
    return textureId;
  }

  Future<void> dispose() =>
      _channel.invokeMethod('dispose', {'textureId': textureId});

  bool get isInitialized => textureId != null;
}

class GstPlayer extends StatefulWidget {
  String pipeline;

  GstPlayer({Key? key, required this.pipeline}) : super(key: key);

  @override
  State<GstPlayer> createState() => _GstPlayerState();
}

class _GstPlayerState extends State<GstPlayer> with TickerProviderStateMixin {
  final _controller = GstPlayerTextureController();
  GlobalKey key = GlobalKey();
  @override
  void initState() {
    initializeController();
    super.initState();
  }

  @override
  void didUpdateWidget(GstPlayer oldWidget) {
    if (widget.pipeline != oldWidget.pipeline) {
      initializeController();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<Null> initializeController() async {
    await _controller.initialize(
      widget.pipeline,
    );
    print("pipeline: ${widget.pipeline}");
    setState(() {});
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Platform.operatingSystem;

    switch (currentPlatform) {
      case 'linux':
      case 'android':
        print("gstreamer ANDROID textureId: ${_controller.textureId}");
        return Container(
          child: _controller.isInitialized
              ? Texture(textureId: _controller.textureId)
              : null,
        );

      case 'ios':
        String viewType = _controller.textureId.toString();
        final Map<String, dynamic> creationParams = <String, dynamic>{};
        print("gstreamer IOS textureId: ${_controller.textureId} ");
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}
