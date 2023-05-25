import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let registrar = self.registrar(forPlugin: "clipper_demo_plugin")!
    let redFactory = FLNativeViewFactory(messenger: registrar.messenger(), color: UIColor.red)
    registrar.register(redFactory, withId: "red_view")
    let blueFactory = FLNativeViewFactory(messenger: registrar.messenger(), color: UIColor.blue)
    registrar.register(blueFactory, withId: "blue_view")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var color: UIColor

    init(messenger: FlutterBinaryMessenger, color: UIColor) {
        self.messenger = messenger
        self.color = color
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            color: color
        )
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        color: UIColor
    ) {
        _view = UIView(frame: frame)
        _view.backgroundColor = color
        super.init()
    }

    func view() -> UIView {
        return _view
    }
}

