import Flutter
import UIKit

public class NqMediaPlayerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var channel: FlutterMethodChannel?
  private var eventChannel: FlutterEventChannel?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = NqMediaPlayerPlugin()
    instance.setupChannels(registrar: registrar)
  }
  
  private func setupChannels(registrar: FlutterPluginRegistrar) {
    // 设置 MethodChannel
    channel = FlutterMethodChannel(name: "nq_media_player", 
                                 binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(self, channel: channel!)
    
    // 设置 EventChannel
    eventChannel = FlutterEventChannel(name: "nq_media_player/event", 
                                     binaryMessenger: registrar.messenger())
    eventChannel?.setStreamHandler(self)
    
    // 初始化 AudioUtil
    AudioUtil.getInstance().initialize()
  }
  
  public func detachFromEngine() {
    AudioUtil.getInstance().close()
    channel?.setMethodCallHandler(nil)
    channel = nil
    eventChannel?.setStreamHandler(nil)
    eventChannel = nil
    eventSink = nil
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result(UIDevice.current.systemVersion)
      
    case "switchMusicOn":
      do {
        AudioUtil.getInstance().playOrPauseMusic()
        result(true)
      } catch {
        result(FlutterError(code: "AUDIO_ERROR",
                          message: "Failed to control audio playback",
                          details: error.localizedDescription))
      }
      
    case "isMusicOn":
      result(AudioUtil.getInstance().isMusicActive())
      
    case "nextMusic":
      do {
        AudioUtil.getInstance().nextMusic()
        result(true)
      } catch {
        result(FlutterError(code: "AUDIO_ERROR",
                          message: "Failed to control next track",
                          details: error.localizedDescription))
      }
      
    case "lastMusic":
      do {
        AudioUtil.getInstance().lastMusic()
        result(true)
      } catch {
        result(FlutterError(code: "AUDIO_ERROR",
                          message: "Failed to control previous track",
                          details: error.localizedDescription))
      }
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // 实现 FlutterStreamHandler 协议
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    CallbackImpl.shared().setEventSink(events)
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    CallbackImpl.shared().setEventSink(nil)
    return nil
  }
  
  deinit {
    AudioUtil.getInstance().close()
    channel?.setMethodCallHandler(nil)
    channel = nil
    eventChannel?.setStreamHandler(nil)
    eventChannel = nil
    eventSink = nil
  }
}
