// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

class GstPlayerTextureController {
  static const MethodChannel _channel =
      MethodChannel('flutter_gstreamer_player');
  int textureId = 0;

  static const int _id = 0;

  Future<int> initialize(String pipeline) async {
    // No idea why, but you have to increase `_id` first before pass it to method channel,
    // if not, receiver of method channel always received 0

    // GstPlayerTextureController._id = GstPlayerTextureController._id + 1;
    textureId = await _channel.invokeMethod('PlayerRegisterTexture', {
      'pipeline': pipeline,
      'playerId': GstPlayerTextureController._id,
      'surface': 0,
    });
    print(textureId.toString());
    return textureId;
  }

  Future<String> versionAndroid() async {
    String platformVersionAndroid = "";
    platformVersionAndroid =
        await _channel.invokeMethod('getPlatformVersion', {});
    print("platformVersionAndroid $platformVersionAndroid");
    return platformVersionAndroid;
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
  bool isReceive = true;
  late FlutterGifController controllerGif;
  @override
  void initState() {
    super.initState();
    initializeController();
    // udpreceive();
    controllerGif = FlutterGifController(vsync: this);
    controllerGif.repeat(
        min: 0, max: 29, period: const Duration(milliseconds: 2500));
  }

  @override
  void didUpdateWidget(GstPlayer oldWidget) {
    if (widget.pipeline != oldWidget.pipeline) {
      initializeController();
      print("pipeline: ${widget.pipeline}");
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> initializeController() async {
    await _controller.initialize(widget.pipeline);
    if (Platform.isAndroid) {
      await _controller.versionAndroid();
    }
    setState(() {});
  }

  //     final udpSocket =
  //         await RawDatagramSocket.bind(InternetAddress.anyIPv4, udpPort);
  //     udpSocket.listen((RawSocketEvent event) {
  //       if (event == RawSocketEvent.read) {
  //         final datagram = udpSocket.receive();
  //         if (datagram != null) {
  //           print(
  //               'Données UDP reçues depuis ${datagram.address}:${datagram.port}');
  //           isReceive = true;
  //           setState(() {});
  //         }
  //       }
  //     });
  //     isReceive = false;
  //     print('En attente de données UDP sur le port $udpPort...');
  //     setState(() {});
  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;

    switch (currentPlatform) {
      case TargetPlatform.linux:
      case TargetPlatform.android:
        return Container(
            child: isReceive
                ? Stack(
                    children: [
                      Container(
                        color: Colors.amber,
                      ),
                      Texture(key: key, textureId: _controller.textureId),
                    ],
                  )
                : Container(
                    color: Colors.amber,
                  )
            // : GifImage(
            //     width: double.infinity,
            //     height: double.infinity,
            //     repeat: ImageRepeat.repeat,
            //     controller: controllerGif,
            //     image: const AssetImage("assets/images/neige.gif"),
            //   ),
            );

      case TargetPlatform.iOS:
        String viewType = _controller.textureId.toString();
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
