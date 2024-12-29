package com.nq.nq_media_player;
import android.content.Context;

import androidx.annotation.NonNull;

import com.nq.nq_media_player.utils.audio.AudioUtil;

import java.lang.ref.WeakReference;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

/** NqMediaPlayerPlugin */
public class NqMediaPlayerPlugin implements FlutterPlugin{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private EventChannel eventChannel;

  private Context context;
  private WeakReference<Context> contextWeakReference;

  private MethodCallHandlerImpl methodCallHandler;
  private StreamHandlerImpl streamHandler;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    contextWeakReference = new WeakReference<>(context);

    AudioUtil.getInstance().init(contextWeakReference);

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "nq_media_player");
    methodCallHandler = new MethodCallHandlerImpl();
    channel.setMethodCallHandler(methodCallHandler);

    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "nq_media_player/event");
    streamHandler = new StreamHandlerImpl();
    eventChannel.setStreamHandler(streamHandler);

  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    AudioUtil.getInstance().close();
    contextWeakReference.clear();
    contextWeakReference = null;
    context = null;

    channel.setMethodCallHandler(null);
    methodCallHandler = null;
    channel = null;

    eventChannel.setStreamHandler(null);
    streamHandler = null;
    eventChannel = null;

  }
}
