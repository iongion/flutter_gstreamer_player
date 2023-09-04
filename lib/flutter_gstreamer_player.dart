// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class GstPlayerTextureController {
  static const MethodChannel _channel =
      MethodChannel('flutter_gstreamer_player');
  int textureId = 0;
  static int _id = 0;

  Future<int> initialize(String pipeline) async {
    // No idea why, but you have to increase `_id` first before pass it to method channel,
    // if not, receiver of method channel always received 0
    GstPlayerTextureController._id = GstPlayerTextureController._id + 1;

    textureId = await _channel.invokeMethod('PlayerRegisterTexture', {
      'pipeline': pipeline,
      'playerId': GstPlayerTextureController._id,
    });

    return textureId;
  }

  Future<void> dispose() {
    return _channel.invokeMethod('dispose', {'textureId': textureId});
  }

  bool get isInitialized => textureId != null;
}

class GstPlayer extends StatefulWidget {
  String pipeline;
  GstPlayerTextureController controller;

  GstPlayer({Key? key, required this.pipeline, required this.controller})
      : super(key: key);

  @override
  State<GstPlayer> createState() => _GstPlayerState();
  void dispose() {
    controller.dispose();
  }
}

class _GstPlayerState extends State<GstPlayer> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initializeController();
  }

  @override
  void didUpdateWidget(GstPlayer oldWidget) {
    if (widget.pipeline != oldWidget.pipeline) {
      initializeController();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> initializeController() async {
    await widget.controller.initialize(
      widget.pipeline,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;

    switch (currentPlatform) {
      case TargetPlatform.linux:
      case TargetPlatform.android:
        return Container(
            child: widget.controller.isInitialized
                ? Texture(textureId: widget.controller.textureId)
                : null);

      case TargetPlatform.iOS:
        String viewType = widget.controller.textureId.toString();
        final Map<String, dynamic> creationParams = <String, dynamic>{};
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
