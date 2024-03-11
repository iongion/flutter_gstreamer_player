#ifndef FLUTTER_PLUGIN_FLUTTER_GSTREAMER_PLAYER_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_GSTREAMER_PLAYER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_gstreamer_player {

class FlutterGstreamerPlayerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterGstreamerPlayerPlugin();

  virtual ~FlutterGstreamerPlayerPlugin();

  // Disallow copy and assign.
  FlutterGstreamerPlayerPlugin(const FlutterGstreamerPlayerPlugin&) = delete;
  FlutterGstreamerPlayerPlugin& operator=(const FlutterGstreamerPlayerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_gstreamer_player

#endif  // FLUTTER_PLUGIN_FLUTTER_GSTREAMER_PLAYER_PLUGIN_H_
