import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_gstreamer_player_platform_interface.dart';

/// An implementation of [FlutterGstreamerPlayerPlatform] that uses method channels.
class MethodChannelFlutterGstreamerPlayer extends FlutterGstreamerPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_gstreamer_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
