import Flutter
import UIKit

// class CFLNativeViewFactory, sous classe: NSObject , implémente le prototcole: FlutterPlatformViewFactory
class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
  // propriétés de la classe
  private var messenger: FlutterBinaryMessenger
  private var pipeline: String
  
  // constructeur
  init(messenger: FlutterBinaryMessenger, pipeline: String) {
    self.messenger = messenger
    self.pipeline = pipeline
    super.init()
  }

  // frame: un rectangle qui définit la taille et la position de la vue native.
  // viewId: un identifiant unique pour la vue.
  // args: des arguments qui peuvent être utilisés pour personnaliser la vue native.
  func create(
      withFrame frame: CGRect,
      viewIdentifier viewId: Int64,
      arguments args: Any?
  ) -> FlutterPlatformView {
  // retourne la vue native avec les parametre frame,viewId,args,messenger,pipeline
    return FLNativeView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger,
      pipeline: pipeline)
  }
}

// class FLNativeView, sous classe: NSObject , implémente le prototcole: FlutterPlatformView
class FLNativeView: NSObject, FlutterPlatformView {
  // propriétés de la classe
  // _view: Une instance de UIView qui sera utilisée pour afficher le contenu de la vue native.
  private var _view: UIView
  // _gStreamerBackend: Une instance de GStreamerBackend, qui semble être utilisée pour gérer la lecture de flux vidéo, avec un pipeline défini dans les commentaires.
  private var _gStreamerBackend: GStreamerBackend


  // constructeur
  // frame: la taille de la vue
  // viewId: l'identifiant de la vue
  // args: arguments optionnels
  // messenger: messager binaire Flutter
  // pipeline: pipeline de GStreamer
  init(
      frame: CGRect,
      viewIdentifier viewId: Int64,
      arguments args: Any?,
      binaryMessenger messenger: FlutterBinaryMessenger?,
      pipeline pipeline: String
  ) {
    // renvoie l'instance de _view, qui sera utilisée comme vue native
    _view = UIView()
      /*
    print("[FLNativeView] viewId: " + String(viewId))
    switch (viewId) {
      case 0:
        //_pipeline = "videotestsrc pattern=smpte ! warptv ! videoconvert ! autovideosink"
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 retry=60000 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
      case 1:
        //_pipeline = "videotestsrc pattern=circular ! warptv ! videoconvert ! autovideosink"
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 retry=60000 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
      case 2:
        //_pipeline = "videotestsrc pattern=checkers-8 ! warptv ! videoconvert ! autovideosink"
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 retry=60000 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
      case 3:
        //_pipeline = "videotestsrc pattern=smpte100 ! warptv ! videoconvert ! autovideosink"
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 retry=60000 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
      default:
        _pipeline = "rtspsrc location=rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4 latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.55.1:9000/sony latency=0 ! decodebin ! autovideosink"
        //_pipeline = "rtspsrc location=rtsp://192.168.0.103:9000/sony latency=0 ! decodebin ! autovideosink"
        break
    }
    */
    _gStreamerBackend.dealloc()
    result("dealloc on FLNativeViewFactory")
    _gStreamerBackend = GStreamerBackend(
      pipeline,
      videoView: _view)
    result("innit _gStreamerBackend on FLNativeViewFactory")
    super.init()
    // iOS views can be created here
    //createNativeView(view: _view)
  }

  func view() -> UIView {
    return _view
  }

  // personnaliser la vue native en ajoutant un label de texte à la vue
  func createNativeView(view _view: UIView){
    _view.backgroundColor = UIColor.blue
    let nativeLabel = UILabel()
    nativeLabel.text = "Native text from iOS: " + String("")
    nativeLabel.textColor = UIColor.white
    nativeLabel.textAlignment = .center
    nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
    _view.addSubview(nativeLabel)
  }
}
// class SwiftFlutterGstreamerPlayerPlugin, sous classe: NSObject , implémente le prototcole: FlutterPlugin
public class SwiftFlutterGstreamerPlayerPlugin: NSObject, FlutterPlugin {

  // propriétés de la classe
  // registrar: est définie pour stocker l'instance du registraire de plugin Flutter
  //  Le registraire est utilisé pour enregistrer des factories et gérer les canaux de communication Flutter.
  static var registrar: FlutterPluginRegistrar? = nil;
  // gstreamerBackend: est utilisée pour stocker une instance de GStreamerBackend
  var gstreamerBackend: GStreamerBackend?

  // methode register
  // appelée lors de l'enregistrement du plugin dans Flutter
  public static func register(with registrar: FlutterPluginRegistrar) {
    // channel: canal de méthode Flutter
    let channel = FlutterMethodChannel(name: "flutter_gstreamer_player", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterGstreamerPlayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // initialise des composants liés à GStreamer
    gst_ios_init()

    // registrar est mise à jour avec l'instance du registraire Flutter
    SwiftFlutterGstreamerPlayerPlugin.registrar = registrar
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
        break
      case "dispose":
            result("Dispose moethod not implemented")
        break
      case "PlayerRegisterTexture":
        guard let args = call.arguments as? [String : Any] else {
          result(" arguments error.... ")
          return
        }
        let pipeline = args["pipeline"] as! String;
        let playerId = args["playerId"] as! Int64;

        guard let registrar = SwiftFlutterGstreamerPlayerPlugin.registrar as? FlutterPluginRegistrar else {
          print("Internal plugin error: registrar does not initialized")
          return
        }

        var factory = FLNativeViewFactory(messenger: registrar.messenger(), pipeline: pipeline)
       
        registrar.register(factory, withId: String(playerId))

        result(playerId)
        break
      default:
        result(FlutterMethodNotImplemented)
        break
    }
  }
}
